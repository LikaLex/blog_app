class RatePostService
  def initialize(post_id, mark_value)
    @post_id = post_id
    @mark_value = mark_value
  end

  def call
    post.marks.create!(value: mark_value)
    post.update(rating: rating)
    rating
  end

  private
  attr_reader :post_id, :mark_value

  def post
    @post ||= Post.find(post_id).lock!
  end

  def rating
    @rating ||= post.marks.average(:value)
  end
end