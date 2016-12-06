module Gobstones
  class Checker < Mumukit::Metatest::Checker
    def check_final_board(result, expected)
      actual = result[:table]

      if clean(actual) != clean(expected)
        error = { expected: expected, actual: actual }
        fail error
      end
    end

    # // TODO postconditions que faltan: return, boom

    def render_success_output(result)
      renderer.render result
    end

    def render_error_output(result, error)
      to_render = { error: error } # // TODO: error es un String :/
      renderer.render to_render
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
