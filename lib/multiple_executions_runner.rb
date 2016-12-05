module Gobstones
  class MultipleExecutionsRunner
    def initialize(examples)
      @examples = examples
    end

    def run(output, example)
      execution = output[@examples.index example]

      result = execution[:result]
      hasErrors = execution[:status] != :passed.to_s

      raise Mumukit::Metatest::Errored, result if hasErrors
      result
    end
  end
end
