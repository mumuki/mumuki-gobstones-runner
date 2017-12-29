require 'sinatra/base'

class Mumukit::Server::App < Sinatra::Base
  def self.get_asset(route, path)
    get "/assets/#{route}" do
      send_file File.expand_path("bower_components/#{path}")
    end
  end

  get_asset 'webcomponents.js', 'webcomponentsjs/webcomponents.min.js'
  get_asset 'polymer.html', 'gs-board/dist/polymer.html'
  get_asset 'gs-board.html', 'gs-board/dist/gs-board.html'
end
