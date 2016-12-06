module Gobstones
  class HtmlRenderer
    def render_success(result)
      @result = {
        initial_board: adapt_to_view(result[:initialBoard]),
        final_board: adapt_to_view(result[:finalBoard])
      }

      bind
    end

    def render_error_check_final_board_failed(result)
      adapted_boards = result.map { | k, v |
        [ k, adapt_to_view(v) ]
      }.to_h

      @result = {
        error: :check_final_board_failed
      }.merge adapted_boards

      bind
    end

    private

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
