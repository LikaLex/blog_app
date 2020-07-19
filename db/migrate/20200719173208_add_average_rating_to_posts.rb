class AddAverageRatingToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :rating, :float
  end
end
