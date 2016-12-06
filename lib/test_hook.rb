class GobstonesTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :examples

  structured true
  isolated false # // TODO: No such file or directory - connect(2) for /var/run/docker.sock

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gs-weblang-cli --batch #{filename} --format gbb"
    # // TODO: Agregarle que devuelva en ambos formatos el tablero inicial y final
  end

  def compile_file_content(request)
    test = parse_test(request)
    @examples = to_examples(test)

    @examples
      .map { |example|
        {
          initialBoard: example[:initial_board],
          code: request.extra + "\n" + request.content
          # // TODO y los :arguments?
        }
      }.to_json
  end

  def post_process_file(file, result, status)
    output = parse_json result

    case status
      when :passed
        test_with_framework output, @examples
      when :failed
        [output, :errored]
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
        postconditions: example.except_keys(preconditions)
      }.merge example.only_keys(preconditions)
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

  def parse_json(json_result)
    JSON.parse(json_result).map(&:deep_symbolize_keys)
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end
end
