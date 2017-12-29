require 'sinatra/base'

class Mumukit::Server::App < Sinatra::Base
  def self.get_asset(route, path, type)
    get "/assets/#{route}" do
      send_file File.expand_path("bower_components/#{path}"), { type: type }
    end
  end

  get_asset 'webcomponents.js', 'webcomponentsjs/webcomponents.min.js', 'application/javascript'
  get_asset 'polymer.html', 'gs-board/dist/polymer.html', 'text/html'
  get_asset 'gs-board.html', 'gs-board/dist/gs-board.html', 'text/html'
end
