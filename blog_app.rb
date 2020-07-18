require "sinatra"

class BlogApp < Sinatra::Base
  get '/' do
    'Welcome to BookList!'
  end
end
