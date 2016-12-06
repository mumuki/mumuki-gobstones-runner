module Gobstones
  class HtmlRenderer
    def render_success(initial_board, final_board)
      @result = {
        initial_board: initial_board,
        final_board: final_board
      }
      bind
    end

    def render_error(error)
      @result = { error: error }
      bind
    end

    private

    def bind
      template_file.result binding
    end

    def template_file
      ERB.new File.read("#{__dir__}/boards.html.erb")
    end
  end
end
