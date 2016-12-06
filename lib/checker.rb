module Gobstones
  class Checker < Mumukit::Metatest::Checker
    def check_final_board(result, expected)
      actual = result[:finalBoard][:table][:gbb]

      if clean(actual) != clean(expected)
        report = {
          status: :check_equal_failed,
          result: {
            initial: result[:initialBoard],
            expected: result[:extraBoard],
            actual: actual[:finalBoard]
          }
        }
        fail JSON.generate(report)
      end
    end

    # // TODO postconditions que faltan: return, boom

    def render_success_output(result)
      renderer.render_success result[:initialBoard], result[:finalBoard]
    end

    def render_error_output(result, error)
      report = JSON.parse(error)
      renderer.render_error report
    end

    private

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new
    end

    def clean(gbb)
      gbb.gsub /\r|\n/, ""
    end
  end
end
