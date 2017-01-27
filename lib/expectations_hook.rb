class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'GobstonesAst'
  end
end
