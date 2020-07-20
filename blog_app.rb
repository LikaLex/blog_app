# frozen_string_literal: true
class BlogApp < Sinatra::Base
  helpers Sinatra::JSON
  DEFAULT_LIMIT = 50

  set :show_exceptions, :after_handler

  post '/posts' do
    user = User.find_or_create_by(login: request_payload[:login])
    post = user.posts.new(
      author_ip: request_payload[:author_ip],
      title: request_payload[:title],
      content: request_payload[:content]
    )
    post.save!
    json post.attributes
  end

  get '/posts' do
    posts = Post.order(rating: :desc).page(params[:page]).per(params[:limit] || DEFAULT_LIMIT)
    json posts.map { |post| post.attributes.slice('title', 'content') }
  end

  post '/marks' do
    rating = RatePostService.new(*request_payload.values_at(:post_id, :value)).call
    json rating: rating
  end

  get '/suspicious_ips' do
    json Post
      .joins(:user)
      .group('posts.author_ip')
      .select('posts.author_ip, array_agg(distinct users.login) as authors')
      .having('array_length(array_agg(distinct users.login), 1) > 1').map do |tuple|
      tuple.attributes.slice('author_ip', 'authors')
    end
  end

  error StandardError do
    status :unprocessable_entity
    json error: env['sinatra.error']
  end

  private

  def request_payload
    @request_payload ||= Oj.load(request.body.read).with_indifferent_access
  end

  # def render_error(error, status = nil)
  #   status status || :unprocessable_entity
  #   json error: error
  # end
end
