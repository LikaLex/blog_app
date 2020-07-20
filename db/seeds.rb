require 'faker'
posts_url = 'http://localhost:9292/posts'
mark_post_url = 'http://localhost:9292/marks'

logins, ips = [], []

100.times do
  logins.push( Faker::Name.name)
end

50.times do
  ips.push(Faker::Internet.private_ip_v4_address)
end

200000.times do
  Faraday.post(posts_url, Oj.dump({title: Faker::Book.title, content: Faker::Hacker.say_something_smart,
                                   login: logins[rand(99)], author_ip: ips[rand(49)]  }),
               "Content-Type" => "application/json")
end

post_ids = Post.find_each.map(&:id)

1000.times do
  Faraday.post(mark_post_url, Oj.dump({value: rand(1..5), post_id: rand(post_ids.count - 1)  }),
               "Content-Type" => "application/json")
end

