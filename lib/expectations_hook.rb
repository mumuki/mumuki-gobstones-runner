class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  # no need to implement `language` and `compile_content`
  # since we are completly overriding `mulang_code`
  def mulang_code(request)
    Mulang::Code.external extract_ast(request)
  end

  def compile_expectations(request)
    super(request).tap do |expectations|
      request.precompiled_batch.options[:subject].try do |subject|
        expectations[:ast] << { binding: '*', inspection: "Declares:=#{subject}" }
      end
    end
  end

  def default_smell_exceptions
    LOGIC_SMELLS + FUNCTIONAL_SMELLS + OBJECT_ORIENTED_SMELLS
  end

  def compile_mulang_analysis(*)
    super.tap do |it|
      it[:spec].merge!(
        originalLanguage: "Json",
        autocorrectionRules: positive_and_negative(
          'Uses:==' => 'UsesEqual',
          'Uses:/=' => 'UsesNotEqual',
          'Uses:+' => 'UsesPlus',
          'Uses:-' => 'UsesMinus',
          'Uses:*' => 'UsesMultiply',
          'Uses:/' => 'UsesMinus',
          'Uses:not' => 'UsesNegation',
          'Uses:&&' => 'UsesAnd',
          'Uses:||' => 'UsesOr',
          'Uses:>=' => 'UsesGreatherOrEqualThan',
          'Uses:>' => 'UsesGreatherThan',
          'Uses:<=' => 'UsesLessOrEqualThan',
          'Uses:<' => 'UsesLessThan'
        )
      )
    end
  end

  def positive_and_negative(rules)
    rules.flat_map { |k, v| [[k, v], ["Not:#{k}", "Not:#{v}"]] }.to_h
  end

  private

  def extract_ast(request)
    precompiled_output, precompiled_status = request.precompiled_result

    if precompiled_status.aborted?
      {tag: :None}
    elsif precompiled_output.is_a?(String)
      # gobstones cli miserably failed on parsing the submission or the extra code
      logger.warn("Unprocessable GobstonesCLI output:\n\n#{precompiled_output}")
      {tag: :None}
    elsif (ast = precompiled_output.first.dig(:result, :mulangAst)).blank?
      # gobstones cli could not produce a valid ast
      logger.warn("GobstonesCLI produced an empty AST:\n\n#{precompiled_output}")
      {tag: :None}
    else
      ast
    end
  end
end
