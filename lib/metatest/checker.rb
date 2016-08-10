module Mumukit::Metatest
  class Checker
    def check(value, example)
      example[:postconditions].each { |key, arg| check_assertion key, value, arg, example }
      [example[:name], :passed, nil]
    rescue => e
      [example[:name], :failed, e.message]
    end

    def check_assertion(key, value, arg, example)
      send "check_#{key}", value, arg
    end

    def fail(message)
      raise Failed, message
    end
  end
end