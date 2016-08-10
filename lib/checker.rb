module Qsim
  class Checker < Mumukit::Metatest::Checker
    def check_compare(result, records)
      records.each do |record, value|
        fail "#{record} should be #{value}, but was #{result[:records][record]}" unless result[:records][record] == value
      end
    end
  end
end