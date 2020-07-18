class BlogApp < Sinatra::Base
  get '/' do
    "Welcome to BookList! #{User.count}"
  end
end
