class Gobstones::Batch
  attr_accessor :options, :examples, :content, :extra

  def initialize(content, examples, extra, options)
    @content = content
    @examples = examples
    @extra = extra
    @options = options
    @checker = Gobstones::Checker.new(options)
  end

  def run_tests!(output)
    Mumukit::Metatest::Framework.new(
      checker: @checker,
      runner: Gobstones::MultipleExecutionsRunner.new).test output, examples
  end

  def warnings
    @checker.warnings
  end

  def to_json
    {
      code: content,
      extraCode: extra,
      examples: examples.map { |example| example_json(example) }
    }.to_json
  end

  private

  def example_json(example)
    expected_board = example[:postconditions][:final_board]
    base = example_base_json(example)
    expected_board ? base.merge(extraBoard: expected_board) : base
  end

  def example_base_json(example)
    example_code = example_code(example)
    base = { initialBoard: example[:preconditions][:initial_board] }
    example_code ? base.merge(generatedCode: example_code) : base
  end

  def example_code(example)
    Gobstones::ExampleCodeBuilder.new(content, example, options).build
  end
end
