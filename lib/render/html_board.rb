require "base64"

module Gobstones
  class HtmlBoard
    attr_reader :gbb, :boom

    def initialize(board, boom = false)
      @gbb = board[:table][:gbb]
      @boom = boom
    end
  end
end
