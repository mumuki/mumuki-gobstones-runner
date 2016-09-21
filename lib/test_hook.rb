class QsimTestHook < Mumukit::Templates::FileHook
  include Mumukit::WithTempfile
  isolated true

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    input_file = create_input_file!
    "runqsim #{filename} 6 #{input_file.path}"
  end

  def compile_file_content(request)
    @examples = parse_test(request)[:examples]

    <<EOF
CALL main

#{request.extra}

main:
#{request.content}
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

  def framework
    Mumukit::Metatest::Framework.new checker: Qsim::Checker.new,
                                     runner: Qsim::MultipleExecutionsRunner.new
  end

  def parse_json(json_result)
    JSON.parse(json_result).map { |it| it.deep_symbolize_keys.except :memory }
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

  def create_input_file!
    initial_states = @examples.each_with_index.map { |example, index| default_initial_state.merge(id: index) }
    write_tempfile! JSON.generate(initial_states)
  end
end