module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]
      execution[:status] = execution[:status].to_sym

      raise Mumukit::Metatest::Errored, error_message(execution) unless success?(execution)
      execution
    end

    private

    def success?(execution)
      [:passed, :runtime_error].include? execution[:status]
    end

    def error_message(execution)
      if execution[:status] != :compilation_error
        return format execution.except(:result).to_json
      end

      error = execution[:result][:finalBoardError]
      format Gobstones::build_error(error)
    end

    def format(error)
      "<pre>#{error}</pre>"
    end
  end
end
