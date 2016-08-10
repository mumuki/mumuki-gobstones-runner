class QsimTestHook < Mumukit::Templates::FileHook
  isolated true
  mashup :extra, :content

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

  def post_process_file(file, result, status)
    output = parse_json result

    case status
      when :passed
        [renderer.render(output), status]
      when :failed
        actual_status = output[:kind] == 'runtime' ? :failed : :errored
        [output[:error], actual_status]
      else
        [output, status]
    end
  end

  private

  def parse_json(json_result)
    JSON.parse(json_result).deep_symbolize_keys
  end
end