module Gobstones
  class ProgramBuilder
    def initialize(options, example)
      @options = options
      @example = example
    end

    def build(code)
      return code unless @options[:subject]

      "#{code}\n" \
      "program {\n" \
      "  #{call_code}\n" \
      "}"
    end

    private

    def call_code()
      subject = @options[:subject]
      invocation = "#{subject}(#{arguments})"

      subject.initial_is_lower? ? "return (#{invocation})" : invocation
    end

    def arguments
      (@example[:preconditions][:arguments] || []).join ","
    end
  end
end
