module Gobstones
  class ProgramBuilder
    def initialize(options, example)
      @options = options
      @example = example
    end

    def build(code)
      return code unless subject
<<GBS
#{code}
program {
   #{code_call}
}
GBS
    end

    private

    def code_call
      subject.initial_is_lower? ? "return (#{invocation})" : invocation
    end

    def subject
      @options[:subject]
    end

    def invocation
      "#{subject}(#{arguments})"
    end

    def arguments
      (@example[:preconditions][:arguments] || []).join ','
    end
  end
end
