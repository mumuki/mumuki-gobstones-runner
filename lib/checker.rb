module Gobstones
  class Checker < Mumukit::Metatest::Checker
    # def check_equal(result, records)
    #   records.each do |record, expected|
    #     actual = result[:records][record]
    #     fail I18n.t :check_equal_failure, {record: record, expected: expected, actual: actual} unless actual == expected
    #   end
    # end

    def check_final_board(actual, expected)
      return
    end

    def render_success_output(result)
      renderer.render result
    end

    def render_error_output(result, error)
      "#{error}\n#{renderer.render result}"
    end

    private

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new
    end
  end
end
