class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  # no need to implement `language` and `compile_content`
  # since we are completly overriding `mulang_code`
  def mulang_code(request)
    output, status = request.result
    Mulang::Code.external extract_ast(output)
  end

  def compile_expectations(request)
    super(request).tap do |expectations|
      request.batch.options[:subject].try do |subject|
        expectations[:ast] << { binding: '*', inspection: "Declares:=#{subject}" }
      end
    end
  end

  def default_smell_exceptions
    LOGIC_SMELLS + FUNCTIONAL_SMELLS + OBJECT_ORIENTED_SMELLS
  end

  private

  def extract_ast(precompiled_output)
    if precompiled_output.is_a?(String)
      # gobstones cli miserably failed on parsing the submission or the extra code
      logger.warn("Unprocessable GobstonesCLI output:\n\n#{precompiled_output}")
      {tag: :None}
    elsif precompiled_output.first.dig(:result, :mulangAst).blank?
      # gobstones cli could not produce a valid ast
      logger.warn("GobstonesCLI produced an empty AST:\n\n#{precompiled_output}")
      {tag: :None}
    else
      precompiled_output.first[:result][:mulangAst]
    end
  end
end
