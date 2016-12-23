module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]
      execution[:status] = execution[:status].to_sym

      raise Mumukit::Metatest::Errored, error_message(execution) unless is_success?(execution)
      execution
    end

    private

    def is_success?(execution)
      [:passed, :runtime_error].include? execution[:status]
    end

    def error_message(execution)
      if execution[:status] != :compilation_error
        return "<pre>#{execution.except(:result).to_json}</pre>"
      end

      error = execution[:result][:finalBoardError]
      position = error[:on][:range][:start]
      "[#{position[:row]}:#{position[:column]}]: #{error[:message]}"
    end
  end
end
