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

    def explain_program_before_closing_structure_when_program(submission, result)
      if program_instead_of_command?(result) && missing_brace_end?(submission) && function_or_procedure?(submission)
        (submission.match program).try do |it|
          { keyword: last_function_or_procedure(submission) }
        end
      end
    end

    def explain_program_before_closing_structure_when_no_program(submission, result)
      if program_instead_of_command?(result) && missing_brace_end?(submission) && function_or_procedure?(submission)
        if /#{program}/ =~ submission
          nil
        else
          { keyword: last_function_or_procedure(submission) }
        end
      end
    end

    def explain_surplus_closing_brace(_, result)
      if unbalanced_closing_braces? result
        (error_line(result)).try do |it|
          { line: it[1] }
        end
      end
    end

    def explain_upper_function_typo(submission, result)
      if upper_identifier_instead_of_definition? result
        /#{uppercase_function}/ =~ submission
      end
    end

    def explain_upper_procedure_typo(submission, result)
      if upper_identifier_instead_of_definition? result
        /#{uppercase_procedure}/ =~ submission
      end
    end

    def explain_upper_program_typo(submission, result)
      if upper_identifier_instead_of_definition? result
        /#{uppercase_program}/ =~ submission
      end
    end

    def explain_missing_closing_brace_after_procedure(submission, result)
      if procedure_instead_of_command?(result) && missing_brace_end?(submission)
        (error_line(result)).try do |it|
          { line: it[1] }
        end
      end
    end

    def explain_lower_builtin_procedure_typo(submission, result)
      if open_paren_instead_of_assign?(result)
        (submission.match lower_builtin_procedure).try do |it|
          { lower: it[1][0...5], upper: it[1][0...5].capitalize }
        end
      end
    end

    def explain_upper_builtin_function_typo(submission, result)
      if procedure_invocation_instead_of_expression?(result)
        (submission.match upper_builtin_function).try do |it|
          { upper: it[1], lower: it[1].camelize(:lower) }
        end
      end
    end

    def explain_color_typo(_, result)
      if roja_not_defined?(result) || negra_not_defined?(result)
        (result.match color_not_defined).try do |it|
          { color: it[1], rectified_color: rectified_color(it[1]) }
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

    def function_or_procedure?(submission)
      submission.match? function_or_procedure
    end

    def function_or_procedure
      '(function)\s*\w+\s*\([\w\d\s,]*\)\s*{|(procedure)\s*\w+\s*\([\w\d\s,]*\)\s*{'
    end

    def last_function_or_procedure(submission)
      submission.scan(/#{function_or_procedure}/).last.compact.first
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

    def upper_identifier_instead_of_definition?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba una definición \(de programa, función, procedimiento, o tipo\).\nSe encontró: un identificador con mayúsculas.<\/pre>/
    end

    def uppercase_function
      'Function\s'
    end

    def uppercase_procedure
      'Procedure\s'
    end

    def uppercase_program
      'Program[\s{]*'
    end

    def procedure_instead_of_command?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba un comando.\nSe encontró: la palabra clave "procedure".<\/pre>/
    end

    def open_paren_instead_of_assign?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba un operador de asignación \(":="\).\nSe encontró: un paréntesis izquierdo \("\("\).<\/pre>/
    end

    def lower_builtin_procedure
      '(mover[\s(]|poner[\s(]|sacar[\s(])'
    end

    def procedure_invocation_instead_of_expression?(result)
      result.match? /<pre>\[\d+:\d+\]: Se esperaba una expresión.\nSe encontró: una invocación a un procedimiento.<\/pre>/
    end

    def upper_builtin_function
      '(PuedeMover|NroBolitas|HayBolitas)'
    end

    def roja_not_defined?(result)
      color_not_defined? result, 'Roja'
    end

    def negra_not_defined?(result)
      color_not_defined? result, 'Negra'
    end

    def color_not_defined?(result, color)
      result.match?(color_not_defined(color))
    end

    def color_not_defined(color='\w+')
      /<pre>\[\d+:\d+\]: El constructor "(#{color})" no está definido.<\/pre>/
    end

    def rectified_color(color)
      color.chop + "o"
    end
  end
end
