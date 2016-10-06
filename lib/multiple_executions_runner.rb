module Qsim
  class MultipleExecutionsRunner
    def run(output, example)
      result = output.find { |it| it[:id] == example[:id] }

      raise Mumukit::Metatest::Errored, result[:error] if result[:error]
      result
    end
  end
end