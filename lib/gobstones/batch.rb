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
    {
      code: make_content,
      extraCode: make_extra,
      examples: examples.map { |example| example_json(example) }
    }.to_json
  end

  private

  def make_extra
    if @options[:game_framework]
      [extra, render_framework_file('extra.gbs')]
    else
      extra
    end
  end

  def make_content
    if @options[:game_framework]
      content_with_framework_program
    else
      content
    end
  end

  def content_with_framework_program
    if blockly_content?
      xml = Nokogiri::XML(content)
      xml.root.add_child render_framework_file('program.xml')
      xml.to_xhtml.gsub(/\n\s*/, '')
    else
      <<~GBS
        #{content}

        #{render_framework_file 'program.gbs'}
      GBS
        .chop
    end
  end

  def blockly_content?
    Nokogiri::XML(content).errors.empty?
  end

  def render_framework_file(name)
    ERB.new(File.read("lib/game_framework/#{name}.erb")).result
  end

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
