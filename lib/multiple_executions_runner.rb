module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]
      execution[:status] = execution[:status].to_sym

      result = execution[:result]

      raise Mumukit::Metatest::Errored, result unless is_success?(execution)
      execution
    end

    private

    def is_success?(execution)
      [:passed, :runtime_error].include? execution[:status]
    end
  end
end
