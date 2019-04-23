class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Mulang'
  end

  def mulang_code(request)
    output, status = request.result
    Mulang::Code.new(mulang_language, extract_ast(output))
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
      logger.warn(precompiled_output)
      {tag: :None} # this happens when gobstones cli miserably fails on parsing the submission or the extra code
    else
      precompiled_output.first[:result][:mulangAst]
    end
  end
end
