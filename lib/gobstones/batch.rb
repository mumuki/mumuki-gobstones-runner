class Gobstones::Batch
  attr_accessor :options, :examples, :content, :extra

  def initialize(content, examples, extra, options)
    @content = content
    @examples = examples
    @extra = extra
    @options = options
  end

  def run_tests!(output)
    Mumukit::Metatest::Framework.new(
      checker: Gobstones::Checker.new(options),
      runner: Gobstones::MultipleExecutionsRunner.new).test output, examples
  end

  def to_json
    examples.map { |example| example_json(example) }.to_json
  end

  private

  def example_json(example)
    expected_board = example[:postconditions][:final_board]
    base = example_base_json(example)
    expected_board ? base.merge(extraBoard: expected_board) : base
  end

  def example_base_json(example)
    json = {initialBoard: example[:preconditions][:initial_board],
            code: example_code(example),
            extraCode: extra}

    json[:originalCode] = content if json[:code] != content
    json
  end

  def example_code(example)
    Gobstones::ExampleCodeBuilder.new(content, example, options).build
  end
end
