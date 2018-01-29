module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]
      execution[:status] = execution[:status].to_sym

      convert_compilation_to_runtime_errors! execution if compilation_error?(execution)

      raise Mumukit::Metatest::Errored, error_message(execution) unless success?(execution)
      execution
    end

    private

    def success?(execution)
      [:passed, :runtime_error].include? execution[:status]
    end

    def compilation_error?(execution)
      execution[:status] == :compilation_error
    end

    def error_message(execution)
      return format execution.except(:result).to_json if execution[:status] != :compilation_error

      error = execution[:result][:finalBoardError]
      format Gobstones.build_error(error)
    end

    def convert_compilation_to_runtime_errors!(execution)
      if execution[:result][:finalBoardError][:reason][:code].include? 'arity-mismatch'
        execution[:status] = :runtime_error
      end
    end

    def format(error)
      "<pre>#{error}</pre>"
    end
  end
end
