class QsimTestHook < Mumukit::Templates::FileHook
  isolated true
  mashup :extra, :content

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "runqsim #{filename} 6"
  end

  def compile_file_content(request)
    @examples = parse_test(request)[:examples]
    (super request).strip
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
                                     runner: Mumukit::Metatest::IdentityRunner.new
  end

  def parse_json(json_result)
    JSON.parse(json_result).deep_symbolize_keys
  end

  def parse_test(request)
    YAML.load(request.test).deep_symbolize_keys
  end
end