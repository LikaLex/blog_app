class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :author_ip
      t.belongs_to :user, foreign_key: true
    end
  end
end
