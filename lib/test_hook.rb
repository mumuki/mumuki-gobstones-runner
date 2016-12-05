class GobstonesTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :examples

  isolated false # // TODO: No such file or directory - connect(2) for /var/run/docker.sock

  def tempfile_extension
    '.json'
  end

  def command_line(filename)
    "gs-weblang-cli --batch #{filename}"
  end

  def compile_file_content(request)
    @examples = to_examples(parse_test(request)[:examples])
    # p "EXAMPLES:",  @examples # // TODO borrar

    @examples
      .map { |example|
        {
          initialBoard: example[:initial_board],
          code: request.extra + "\n" + request.content
        }
      }.to_json
  end

  def execute!(request)
    result, _ = run_file! compile request
    parse_json result
  end

  def post_process_file(file, result, status)
    output = parse_json result
    # p "OUTPUT", output # // TODO borrar

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

  def to_examples(examples)
    defaults = { preconditions: {} }
    examples.each_with_index.map { |example, index| defaults.merge(example).merge(id: index) }
  end

  def test_with_framework(output, examples)
    Mumukit::Metatest::Framework.new({
      checker: Gobstones::Checker.new,
      runner: Gobstones::MultipleExecutionsRunner.new(examples)
    }).test output, @examples
  end

  def parse_json(json_result)
    JSON.parse(json_result).map(&:deep_symbolize_keys)
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end
end
