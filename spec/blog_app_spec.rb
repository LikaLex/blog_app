require "spec_helper"

RSpec.describe 'BlogApp' do
    describe "create post actions " , type: :request do
      context "with right params" do
        it "create new post" do
          post_json('/posts', { title: "Some title", content: "Content box", login: "mira", author_ip: "120.12.1.111" })
          expect(response_json).to include("author_ip" => "120.12.1.111")
          expect(response_json).to include("title" => "Some title")
          expect(response_json).to include("content" => "Content box")
          expect(last_response.status).to eq 200
        end
      end

      context "validation failed" do
        it "create new post" do
          post_json('/posts', { title: "Some title", login: "mira", author_ip: "120.12.1.111" })
          expect(response_json).to include("error"=>"Validation failed: Content can't be blank")
          expect(last_response.status).to eq 422
        end
      end

      context "create user if not exist" do
        it "create user and post" do
          expect(User.find_by_login("likalex")).to eq nil
          post_json('/posts', { title: "Some title", login: "likalex", content: "Content box", author_ip: "120.12.1.111" })
          expect(User.find_by_login("likalex").login).to eq "likalex"
        end
      end
    end

    describe "create mark actions " , type: :request do
      context "with right params" do
        it "create new mark" do
          user = User.create(login: "mira")
          post = Post.create( title: "Some title", content: "Content box", user_id: user.id, author_ip: "120.12.1.111")
          post_json('/marks', { value: "2", post_id: post.id })
          expect(response_json).to include({"rating"=>"2.0"})
          expect(last_response.status).to eq 200
        end
      end

      context "if post not existed" do
        it "validation failed" do
          post_json('/marks', { value: "2", post_id: 1 })
          expect(response_json).to include({"error"=>"Couldn't find Post with 'id'=1"})
          expect(last_response.status).to eq 422
        end
      end

      context "with wrong value" do
        it "validation failed (value is more than expected)" do
          user = User.create(login: "mira")
          post = Post.create( title: "Some title", content: "Content box", user_id: user.id, author_ip: "120.12.1.111")
          post_json('/marks', { value: "6", post_id: post.id })
          expect(response_json).to include({"error"=>"Validation failed: Value must be less than or equal to 5"})
          expect(last_response.status).to eq 422
        end

        it "validation failed (value is less than expected)" do
          user = User.create(login: "mira")
          post = Post.create( title: "Some title", content: "Content box", user_id: user.id, author_ip: "120.12.1.111")
          post_json('/marks', { value: "0", post_id: post.id })
          expect(response_json).to include({"error"=>"Validation failed: Value must be greater than or equal to 1"})
          expect(last_response.status).to eq 422
        end
      end
    end

end