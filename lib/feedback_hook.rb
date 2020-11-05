class GobstonesFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    GobstonesExplainer.new.explain(content, test_results) if test_results.is_a? String
  end

  class GobstonesExplainer < Mumukit::Explainer
    def explain_program_has_a_name(submission, result)
      if upper_identifier_instead_of_brace? result
        (submission.match malformed_program_header_with_upper_name).try do |it|
          { name: it[1] }
        end
      end
    end

    def malformed_program_header_with_upper_name
      '.*program +([A-Z]\w*)'
    end

    def upper_identifier_instead_of_brace?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba una llave izquierda \("{"\).\nSe encontró: un identificador con mayúsculas.<\/pre>/
    end
  end
end
