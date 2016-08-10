class QsimTestHook < Mumukit::Templates::FileHook
  isolated true

  attr_writer :renderer

  def renderer
    @renderer ||= Qsim::HtmlRenderer.new
  end

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "runqsim #{filename} 6"
  end

  def compile_file_content(request)
    request.content
  end

  def post_process_file(file, result, status)
    output = parse_json result

    case status
      when :passed
        [renderer.render(output), status]
      when :failed
        [output[:error], :errored]
      else
        [output, status]
    end
  end

  private

  def parse_json(json_result)
    JSON.parse(json_result).deep_symbolize_keys
  end
end