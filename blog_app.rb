# frozen_string_literal: true
class BlogApp < Sinatra::Base
  helpers Sinatra::JSON

  post '/posts' do
    begin
      user = User.find_or_create_by(login: request_payload[:login])
      post = user.posts.new(
        author_ip: request_payload[:author_ip],
        title: request_payload[:title],
        content: request_payload[:content]
      )
      post.save!
      json post.attributes
    rescue StandardError => error
      render_error(error)
    end
  end

  post '/marks' do
    begin
      rating = RatePostService.new(*request_payload.values_at(:post_id, :value)).call
      json rating: rating
    rescue StandardError => error
      render_error(error)
    end
  end

  def request_payload
    @request_payload ||= Oj.load(request.body.read).with_indifferent_access
  end

  def render_error(error)
    status :unprocessable_entity
    json error: error
  end
end
