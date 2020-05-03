require "base64"

module Gobstones
  class HtmlRenderer
    def initialize(options)
      @options = options
    end

    def render_success(result)
      board_types = [:initial, :final]
      board_types.reject!{ |it| it === :initial } unless @options[:show_initial_board]
      bind_result boards: prepare_boards(board_types, result),
                  reason: prepare_reason(result[:reason])
    end

    def render_error_check_final_board_failed(result)
      bind_result error: "check.summary.#{result[:summary]}",
                  boards: prepare_boards([:initial, :expected, :actual], result)
    end

    def render_error_check_failed_unexpected_boom(result)
      bind_result error: :check_failed_unexpected_boom,
                  boards: prepare_boards([:initial, :expected, :actual], result),
                  reason: prepare_reason(result[:reason])
    end

    def render_error_check_error_failed_expected_boom(result)
      bind_result error: :check_error_failed_expected_boom,
                  boards: prepare_boards([:initial, :expected, :final], result)
    end

    def render_error_check_return_failed_no_return(result)
      bind_result error: :check_return_failed_no_return,
                  boards: prepare_boards([:initial], result),
                  expected_value: result[:expected_value]
    end

    def render_error_check_return_failed_different_values(result)
      bind_result error: :check_return_failed_different_values,
                  boards: prepare_boards([:initial], result),
                  expected_value: result[:expected_value],
                  actual_value: result[:actual_value]
    end

    def render_error_check_error_failed_another_reason(result)
      bind_result error: :check_error_failed_another_reason,
                  expected_code: I18n.t("code_#{result[:expected_code]}"),
                  reason: prepare_reason(result[:reason])
    end

    private

    def prepare_reason(reason)
      return unless reason
      Gobstones::build_error(reason)
    end

    def prepare_boards(board_types, result)
      visible_board_types(board_types, result).map do |it|
        struct title: "#{it}_board".to_sym,
               board: visible_board(result, it)
      end
    end

    def visible_board_types(board_types, result)
      board_types.select do |it|
        must_show = @options["show_#{it}_board".to_sym]
        result[it] && (must_show.nil? || must_show)
      end
    end

    def visible_board(result, board_types)
      board = result[board_types]

      if board == 'boom'
        HtmlBoard.new(result[:initial], boom: true)
      else
        HtmlBoard.new(board)
      end
    end

    def bind_result(result)
      @result = { boards: [] }.merge result
      template_file.result binding
    end

    def template_file
      ERB.new File.read("#{__dir__}/boards.html.erb")
    end
  end
end
