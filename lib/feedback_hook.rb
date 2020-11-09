class GobstonesFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    GobstonesExplainer.new.explain(content, test_results) if test_results.is_a? String
  end

  class GobstonesExplainer < Mumukit::Explainer
    def explain_program_has_a_name(submission, result)
      if identifier_instead_of_brace? result
        (submission.match malformed_program_header_with_name).try do |it|
          { name: it[1] }
        end
      end
    end

    def explain_program_has_no_opening_curly_brace(submission, result)
      if identifier_instead_of_brace? result
        /#{malformed_program_header_with_no_curly_braces}/ =~ submission
      end
    end

    def explain_program_before_closing_procedure_when_program(submission, result)
      if program_instead_of_command?(result) && missing_brace_end?(submission)
        /#{program}/ =~ submission
      end
    end

    def explain_program_before_closing_procedure_when_no_program(submission, result)
      if program_instead_of_command?(result) && missing_brace_end?(submission)
        /#{program}/ !~ submission ? /#{program}/ !~ submission : nil
      end
    end

    def explain_surplus_closing_brace(_, result)
      if unbalanced_closing_braces? result
        (error_line(result)).try do |it|
          { line: it[1] }
        end
      end
    end

    private

    def malformed_program_header_with_name
      '.*program +([A-Za-z]\w*)'
    end

    def upper_identifier_instead_of_brace?(result)
      identifier_instead_of_brace?(result, 'may')
    end

    def lower_identifier_instead_of_brace?(result)
      identifier_instead_of_brace?(result, 'min')
    end

    def identifier_instead_of_brace?(result, capital='...')
      result.match? /<pre>\[\d+:\d+\]: Se esperaba una llave izquierda \("{"\).\nSe encontró: un identificador con #{capital}úsculas.<\/pre>/
    end

    def malformed_program_header_with_no_curly_braces
      '.*program *\n[\s\n]*[^{]\w+'
    end

    def program_instead_of_command?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba un comando.\nSe encontró: la palabra clave "program".<\/pre>/
    end

    def missing_brace_end?(submission)
      submission.count('{') > submission.count('}')
    end

    def program
      'program\s*{'
    end

    def unbalanced_closing_braces?(result)
      result.match? /<pre>\[\d+:\d+\]: Se encontró un "}" pero no había una llave abierta "{".<\/pre>/
    end

    def error_line(result)
      result.match /<pre>\[(\d+):\d+\]:/
    end
  end
end
