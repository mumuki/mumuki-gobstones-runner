class Gobstones::ExampleCodeBuilder
  def initialize(code, example, options)
    @code = code
    @example = example
    @options = options
  end

  def build
    return @code unless subject
<<GBS
#{@code}
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
