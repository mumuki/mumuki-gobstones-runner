require "base64"

module Gobstones
  class HtmlRenderer
    def initialize(options)
      @options = options
      @polymer_code = encode_board_html "polymer"
      @board_code = encode_board_html "gs-board"
    end

    def render_success(result)
      bind_result boards: prepare_boards([:initial, :final], result),
                  reason: prepare_reason(result[:reason])
    end

    def render_error_check_final_board_failed_different_boards(result)
      bind_result error: :check_final_board_failed_different_boards,
                  boards: prepare_boards([:initial, :expected, :actual], result)
    end

    def render_error_check_final_board_failed_unexpected_boom(result)
      bind_result error: :check_final_board_failed_unexpected_boom,
                  boards: prepare_boards([:initial, :expected, :actual], result),
                  reason: prepare_reason(result[:reason])
    end

    def render_error_check_error_failed_expected_boom(result)
      bind_result error: :check_error_failed_expected_boom,
                  boards: prepare_boards([:initial, :expected, :final], result)
    end

    def render_error_check_error_failed_another_reason(result)
      bind_result error: :check_error_failed_another_reason,
                  error_parameter: I18n.t("code_#{result[:expected_code]}"),
                  reason: prepare_reason(result[:reason])
    end

    private

    def prepare_reason(reason)
      reason[:message] if reason
    end

    def prepare_boards(names, result)
      visible_names(names).map do |it|
        struct title: "#{it}_board".to_sym,
               board: visible_board(result, it)
      end
    end

    def visible_names(names)
      @options[:show_initial_board] ? names : names - [:initial]
    end

    def visible_board(result, name)
      board = result[name]

      if board == :boom.to_s
        adapt_to_view(result[:initial], true)
      else
        adapt_to_view(board)
      end
    end

    def adapt_to_view(board, boom = false)
      return {
        size: { x: board[:sizeX], y: board[:sizeY] }.to_json,
        header: { x: board[:x], y: board[:y] }.to_json,
        table: board[:table][:json].to_json,
        boom: boom
      }
    end

    def encode_board_html(file_name)
      Base64.strict_encode64 File.read("bower_components/gs-board/dist/#{file_name}.html")
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
