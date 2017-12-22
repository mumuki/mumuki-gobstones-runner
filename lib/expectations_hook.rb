class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include Mumukit::Templates::WithIsolatedEnvironment
  include Mumukit::WithTempfile

  include_smells true

  def language
    'Mulang'
  end

  def ast_command_line(filename)
    "gobstones-cli --mulang_ast #{filename}"
  end

  def compile_content(source)
    ast, status = run_get_ast! source

    if status != :passed
      raise Exception.new("Unable to get Mulang AST - Command failed with status: #{status}")
    end

    JSON.parse(ast)
  rescue => e
    raise Mumukit::CompilationError, e
  end

  private

  def run_get_ast!(source)
    file = write_tempfile! source
    run_file! file, :ast_command_line
  end
end
