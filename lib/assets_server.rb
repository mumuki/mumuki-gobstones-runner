require 'sinatra/base'
require 'sinatra/cross_origin'

class Mumukit::Server::App < Sinatra::Base
  register Sinatra::CrossOrigin

  def self.get_asset(route, path, type)
    get "/assets/#{route}" do
      cross_origin
      send_file File.expand_path("bower_components/#{path}"), { type: type }
    end
  end

  get_asset 'webcomponents.js', 'webcomponentsjs/webcomponents.min.js', 'application/javascript'
  get_asset 'polymer.html', 'polymer/polymer.html', 'text/html'
  get_asset 'polymer-mini.html', 'polymer/polymer-mini.html', 'text/html'
  get_asset 'polymer-micro.html', 'polymer/polymer-micro.html', 'text/html'
  get_asset 'gs-board.html', 'gs-board/dist/gs-board.html', 'text/html'
end
