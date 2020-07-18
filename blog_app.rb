class BlogApp < Sinatra::Base
  get '/' do
    "Welcome to BodsadasdasokList! #{User.count}"
  end
end
