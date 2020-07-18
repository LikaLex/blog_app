# frozen_string_literal: true
class BlogApp < Sinatra::Base
  helpers Sinatra::JSON

  post '/posts' do
    user = User.find_or_create_by(login: request_payload[:login])
    post = user.posts.new(
      author_ip: request_payload[:author_ip],
      title: request_payload[:title],
      content: request_payload[:content]
    )
    if post.save
      json post.attributes
    else
      status :unprocessable_entity
      json post.errors.full_messages
    end
  end

  def request_payload
    @request_payload ||= Oj.load(request.body.read).with_indifferent_access
  end
end
