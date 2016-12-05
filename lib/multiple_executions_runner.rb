module Gobstones
  class MultipleExecutionsRunner
    def initialize(examples)
      @examples = examples
    end

    def run(output, example)
      execution = output[@examples.index example]

      result = execution[:result]
      has_errors = execution[:status] != :passed.to_s

      raise Mumukit::Metatest::Errored, result if has_errors
      result
    end
  end
end
