require "base64"

module Gobstones
  class HtmlBoard
    attr_reader :size, :header, :table, :boom

    def initialize(board, boom = false)
      @size = {x: board[:sizeX], y: board[:sizeY]}.to_json
      @header = {x: board[:x], y: board[:y]}.to_json
      @table = board[:table][:json].to_json
      @boom = boom ? 'boom' : ''
    end
  end
end
