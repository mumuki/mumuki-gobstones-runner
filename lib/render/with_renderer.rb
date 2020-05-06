module Gobstones
  module WithRenderer
    def render_success_output(output)
      result = output[:result]

      renderer.render_success initial: result[:initialBoard],
                              final: result[:finalBoard] || 'boom',
                              reason: result[:finalBoardError]
    end

    def build_error_output(builder, example, _, error)
      error.details.deep_symbolize_keys!

      builder.result          = renderer.send "render_error_#{error.message}", error.details
      builder.summary_type    = error.message
      builder.summary_message = I18n.t error.message, error.details
    end

    private

    def renderer
      @renderer ||= Gobstones::HtmlRenderer.new(@options)
    end
  end
end
