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
end
