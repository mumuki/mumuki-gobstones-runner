class GobstonesTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :examples

  structured true
  isolated false # // TODO: Subir container de Docker y probarlo

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gs-weblang-cli --batch #{filename}"
  end

  def compile_file_content(request)
    test = parse_test(request)
    @examples = to_examples(test)

    @examples
      .map { |example|
        {
          initialBoard: example[:initial_board],
          code: request.extra + "\n" + request.content,
          extraBoard: example[:postconditions][:final_board]
          # // TODO ¿y los :arguments? Generar programa dummy que invoque al procedimiento o función que haga el alumno
        }
      }.to_json
  end

  def post_process_file(file, result, status)
    output = result.parse_as_json

    case status
      when :passed
        test_with_framework output, @examples
      else
        [output, status]
    end
  end

  private

  def to_examples(test)
    examples = test[:examples]
    options = to_options test # // TODO: Darle bola a estas options

    examples.each_with_index.map { |example, index|
      {
        id: index,
        postconditions: example.except(*preconditions)
      }.merge example.slice(*preconditions)
    }
  end

  def to_options(test)
    [
      :show_initial_board,
      :check_head_position
    ].map { |it| [it, test[it] || false] }.to_h
  end

  def preconditions
    [:initial_board, :arguments]
  end

  def test_with_framework(output, examples)
    Mumukit::Metatest::Framework.new({
      checker: Gobstones::Checker.new,
      runner: Gobstones::MultipleExecutionsRunner.new
    }).test output, @examples
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end
end
