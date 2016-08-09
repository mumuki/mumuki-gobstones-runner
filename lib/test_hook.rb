class QsimTestHook < Mumukit::Templates::FileHook
  isolated true

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "runqsim #{filename} 6"
  end

  def compile_file_content(request)
    request.content
  end
end