module Qsim
  class Checker < Mumukit::Metatest::Checker
    def check_equal(result, records)
      records.each do |record, expected|
        actual = result[:records][record]
        fail I18n.t :check_compare_failure, {record: record, expected: expected, actual: actual} unless actual == expected
      end
    end
  end
end