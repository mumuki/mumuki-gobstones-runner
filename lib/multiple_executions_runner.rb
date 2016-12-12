module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]

      result = execution[:result]

      raise Mumukit::Metatest::Errored, result unless is_success?(execution)
      result
    end

    private

    def is_success?(execution)
      [:passed, :runtime_error].include? execution[:status].to_sym
    end
  end
end
