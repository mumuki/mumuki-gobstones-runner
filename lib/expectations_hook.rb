class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include Mumukit::WithTempfile

  include_smells true

  def language
    'Mulang'
  end

  def ast_command_line(filename)
    "gobstones-cli --mulang_ast #{filename}"
  end

  def compile_content(source)
    ast, status = isolated_run! write_tempfile!(source)

    if status != :passed
      raise Exception.new("Unable to get Mulang AST - Command failed with status: #{status}")
    end

    ast
  rescue => e
    raise Mumukit::CompilationError, e
  end

  private

  def isolated_run!(file)
    env = Mumukit::IsolatedEnvironment.new
    env.configure!(file) { |filename| ast_command_line(filename) }
    env.run!
  ensure
    env.destroy!
  end
end
