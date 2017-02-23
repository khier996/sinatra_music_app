require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require 'sqlite3'
set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

DATABASE_PATH = File.join(File.dirname(__FILE__), 'data/jukebox.sqlite')
DB = SQLite3::Database.new(DATABASE_PATH)


get '/' do
  @artists = DB.execute('SELECT * FROM artists')
  erb :index
end

get '/about' do
  erb :about
end

get '/artists/:artist_id' do
  artist_id = params[:artist_id]
  @artist_name = DB.execute("SELECT * FROM artists WHERE artists.id = #{artist_id}")
  @artist_albums = DB.execute("SELECT albums.id, albums.title FROM albums
                               JOIN artists ON artists.id = albums.artist_id
                               WHERE artists.id = #{artist_id}")

  erb :artist
end

get '/albums/:album_id' do
  album_id = params[:album_id]
  @album_songs = DB.execute("SELECT tracks.id, tracks.name FROM tracks WHERE tracks.album_id = #{album_id}")

  erb :song
end
