require 'sinatra/base'
require 'sinatra/cross_origin'

class Mumukit::Server::App < Sinatra::Base
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

  def self.get_asset(route, path, type)
    get "/assets/#{route}" do
      send_file Gobstones::Board.assets_path_for(path), { type: type }
    end
  end

  def self.get_local_asset(route, path, type)
    get "/assets/#{route}" do
      send_file File.expand_path("ATEMPORAL/#{path}"), { type: type } # TODO: Mover a una gema
    end
  end

  get_asset 'webcomponents.js',        'javascripts/vendor/webcomponents.min.js',   'application/javascript'
  get_asset 'polymer.html',            'htmls/vendor/polymer.html',                 'text/html'
  get_asset 'polymer-mini.html',       'htmls/vendor/polymer-mini.html',            'text/html'
  get_asset 'polymer-micro.html',      'htmls/vendor/polymer-micro.html',           'text/html'
  get_asset 'gs-board.html',           'htmls/gs-board.html',                       'text/html'
  get_local_asset 'gs-element-blockly.html', 'gs-element-blockly.html',                   'text/html'
  get_local_asset 'gs-element-blockly.css',  'gs-element-blockly.css',                    'text/css'
end
