class TestHook < Mumukit::Templates::FileHook
  isolated false

  def tempfile_extension
    '.qsim'
  end

  def command_line(filename)
    "#{runqsim_command} #{filename} 0"
  end

  def compile_file_content(request)
    request.content
  end

end