module Gobstones
  module WithRenderer
    def render_success_output(output)
      result = output[:result]

      renderer.render_success initial: result[:initialBoard],
                              final: result[:finalBoard] || 'boom',
                              reason: result[:finalBoardError]
    end

    def render_error_output(_output, error)
      report = error.parse_as_json
      renderer.send "render_error_#{report[:status]}", report[:result]
    end

    private

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new(@options)
    end
  end
end
