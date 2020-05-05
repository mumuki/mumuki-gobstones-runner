module Gobstones
  module WithRenderer
    def render_success_output(output)
      result = output[:result]

      renderer.render_success initial: result[:initialBoard],
                              final: result[:finalBoard] || 'boom',
                              reason: result[:finalBoardError]
    end

    def render_error_output_with_details(_output, error_message, error_details)
      error_details.deep_symbolize_keys!
      renderer.send "render_error_#{error_message}", error_details
    end

    private

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new(@options)
    end
  end
end
