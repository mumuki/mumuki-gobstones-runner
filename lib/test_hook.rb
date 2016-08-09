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
    [renderer.render(result), status]
  end
end