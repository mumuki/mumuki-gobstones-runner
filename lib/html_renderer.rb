module Gobstones
  class HtmlRenderer
    def initialize(options)
      @options = options
    end

    def render_success(result)
      bind_result(
        boards: prepare_boards([:initial, :final], result)
      )
    end

    def render_error_check_final_board_failed(result)
      bind_result(
        error: :check_final_board_failed,
        boards: prepare_boards([:initial, :expected, :actual], result)
      )
    end

    def render_error_check_final_board_failed_unexpected_boom(result)
      bind_result(
        error: :check_final_board_failed_unexpected_boom,
        boards: prepare_boards([:initial, :expected, :actual], result),
        reason: prepare_reason(result[:reason])
      )
    end

    def render_error_check_error_failed_expected_boom(result)
      bind_result(
        error: :check_error_failed_expected_boom,
        boards: prepare_boards([:initial, :expected, :final], result)
      )
    end

    def render_error_check_error_failed_another_reason(result)
      bind_result(
        error: :check_error_failed_another_reason,
        expected_code: result[:expected_code],
        reason: prepare_reason(result[:reason])
      )
    end

    private

    def prepare_reason(reason)
      p reason # // TODO: Armar bien la razón
      reason
    end

    def prepare_boards(names, result)
      names.reject { |it|
        it == :initial and not @options[:show_initial_board]
      }.map { |it|
        struct title: "#{it}_board".to_sym,
               board: (
                  if result[it] != :boom.to_s
                    adapt_to_view(result[it])
                  else
                    adapt_to_view(result[:initial], true)
                  end
               )
      }
    end

    def adapt_to_view(board, boom = false)
      return {
        size: JSON.generate({ x: board[:sizeX], y: board[:sizeY]}),
        header: JSON.generate({ x: board[:x], y: board[:y] }),
        table: JSON.generate(board[:table][:json]),
        boom: boom
      }
    end

    def bind_result(result)
      @result = result
      template_file.result binding
    end

    def template_file
      ERB.new File.read("#{__dir__}/boards.html.erb")
    end
  end
end
