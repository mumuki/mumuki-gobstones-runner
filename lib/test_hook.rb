class GobstonesTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :options, :examples

  structured true
  isolated true

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gs-weblang-cli --batch #{filename}"
  end

  def compile_file_content(request)
    test = parse_test request
    @options = to_options test
    @examples = to_examples test, @options

    @examples.map do |example|
      expected_board = example[:postconditions][:final_board]

      code = Gobstones::ProgramBuilder.new(@options, example).build(request.content)
      batch = {
        initialBoard: example[:preconditions][:initial_board],
        code: code + "\n" + request.extra
      }

      if expected_board
        batch.merge extraBoard: expected_board
      else
        batch
      end
    end.to_json
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

  def to_examples(test, options)
    examples = test[:examples]

    examples.each_with_index.map do |example, index|
      transform options, {
        id: index,
        title: example[:title], # // TODO: Sigue sin mostrarlo :(
        preconditions: example.slice(*preconditions),
        postconditions: example.slice(*postconditions)
      }
    end
  end

  def transform(options, example)
    return example unless options[:subject]

    return_value = example[:postconditions][:return]
    if return_value
      example[:title] = "#{options[:subject]}() -> #{return_value}" unless example[:title]
      options[:show_final_board] = false
    end

    example
  end

  def to_options(test)
    [
      struct(key: :show_initial_board, default: true),
      struct(key: :show_final_board, default: true),
      struct(key: :show_expected_board, default: true),
      struct(key: :show_actual_board, default: true),
      struct(key: :check_head_position, default: false),
      struct(key: :subject, default: nil)
    ].map { |it| [it.key, test[it.key] || it.default] }.to_h
  end

  def preconditions
    [:initial_board, :arguments]
  end

  def postconditions
    [:final_board, :error, :return]
  end

  def test_with_framework(output, examples)
    Mumukit::Metatest::Framework.new({
      checker: Gobstones::Checker.new(@options),
      runner: Gobstones::MultipleExecutionsRunner.new
    }).test output, @examples
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end
end
