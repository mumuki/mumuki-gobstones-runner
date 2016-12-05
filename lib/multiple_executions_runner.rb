module Gobstones
  class MultipleExecutionsRunner
    def run(output, example)
      execution = output[example[:id]]

      result = execution[:result]
      has_errors = execution[:status] != :passed.to_s

      raise Mumukit::Metatest::Errored, result if has_errors
      result
    end
  end
end
