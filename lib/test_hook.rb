class QsimTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  attr_reader :examples

  isolated true

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "runqsim #{filename} #{q_architecture} #{input_file_separator}"
  end

  def compile_file_content(request)
    @examples = to_examples(parse_test(request)[:examples])

    <<EOF
JMP main

#{request.extra}

main:
#{request.content}
#{input_file_separator}
#{initial_state_file}
EOF
  end

  def execute!(request)
    result, _ = run_file! compile request
    parse_json result
  end

  def post_process_file(file, result, status)
    output = parse_json result

    case status
      when :passed
        framework.test output, @examples
      when :failed
        [output[:error], :errored]
      else
        [output, status]
    end
  end

  private

  def to_examples(examples)
    defaults = { preconditions: {} }
    examples.each_with_index.map { |example, index| defaults.merge(example).merge(id: index) }
  end

  def framework
    Mumukit::Metatest::Framework.new checker: Qsim::Checker.new,
                                     runner: Qsim::MultipleExecutionsRunner.new
  end

  def parse_json(json_result)
    JSON.parse(json_result).map(&:deep_symbolize_keys)
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end

  def default_initial_state
    {
      special_records: {
        PC: '0000',
        SP: 'FFEF',
        IR: '0000'
      },
      flags: {
        N: 0,
        Z: 0,
        V: 0,
        C: 0
      },
      records: {
        R0: '0000',
        R1: '0000',
        R2: '0000',
        R3: '0000',
        R4: '0000',
        R5: '0000',
        R6: '0000',
        R7: '0000'
      },
      memory: {}
    }
  end

  def initial_state_file
    initial_states = @examples.map { |example| default_initial_state.merge(id: example[:id]).deep_merge(example[:preconditions]) }
    JSON.generate initial_states
  end

  def input_file_separator
    '!!!BEGIN_EXAMPLES!!!'
  end

  def q_architecture
    6
  end
end