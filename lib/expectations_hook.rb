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

  def compile_expectations_and_exceptions(request)
    expectations, exceptions = super request

    subject = request.batch.options[:subject]
    expectations << { binding: '*', inspection: "Declares:=#{subject}" } if subject

    [expectations, exceptions]
  end
end
