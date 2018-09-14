class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Mulang'
  end

  def mulang_code(request)
    output, status = request.result

    ast = output.first[:result][:mulangAst]
    Mulang::Code.new(mulang_language, ast)
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
end
