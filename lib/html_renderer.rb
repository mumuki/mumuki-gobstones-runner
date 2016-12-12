module Gobstones
  class HtmlRenderer
    def initialize(options)
      @options = options
    end

    def render_success(result)
      @result = {
        boards: prepare_boards([:initial, :final], result)
      }

      bind
    end

    def render_error_check_final_board_failed(result)
      @result = {
        error: :check_final_board_failed,
        boards: prepare_boards([:initial, :expected, :actual], result)
      }

      bind
    end

    def render_error_check_error_failed_expected_boom(result)
      # // TODO
    end

    def render_error_check_error_failed_another_reason(result)
      # // TODO
    end

    private

    def prepare_boards(names, result)
      names.reject { |it|
        it == :initial and not @options[:show_initial_board]
      }.map { |it|
        struct title: "#{it}_board".to_sym, board: adapt_to_view(result[it])
      }
    end

    def adapt_to_view(board)
      return {
        size: JSON.generate({ x: board[:sizeX], y: board[:sizeY]}),
        header: JSON.generate({ x: board[:x], y: board[:y] }),
        table: JSON.generate(board[:table][:json])
      }
    end

    def bind
      template_file.result binding
    end

    def template_file
      ERB.new File.read("#{__dir__}/boards.html.erb")
    end
  end
end
