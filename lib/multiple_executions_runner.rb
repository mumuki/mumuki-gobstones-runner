module Qsim
  class MultipleExecutionsRunner
    def run(output, example)
      result = output.first

      raise Mumukit::Metatest::Errored, result[:error] if result[:error]
      result
    end
  end
end