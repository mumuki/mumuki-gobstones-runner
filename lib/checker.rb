module Gobstones
  class Checker < Mumukit::Metatest::Checker
    def check_final_board(result, expected)
      actual = result[:table]

      if clean(actual) != clean(expected)
        fail I18n.t :check_final_board_failure, { expected: expected, actual: actual }
      end
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

    def clean(gbb)
      gbb.gsub /\r|\n/, ""
    end
  end
end
