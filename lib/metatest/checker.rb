module Mumukit::Metatest
  class Checker
    def check(value, example)
      example[:postconditions].each { |key, arg| check_assertion key, value, arg, example }
      [example[:name], :passed, make_success_output(value)]
    rescue => e
      [example[:name], :failed, make_error_output(value, e.message)]
    end

    def make_success_output(value)
      nil
    end

    def make_error_output(value, error)
      error
    end

    def check_assertion(key, value, arg, example)
      send "check_#{key}", value, arg
    end

    def fail(message)
      raise Failed, message
    end
  end
end