# frozen_string_literal: true

class CreateMarks < ActiveRecord::Migration[5.2]
  def change
    create_table :marks do |t|
      t.integer :value
      t.belongs_to :post, foreign_key: { on_delete: :cascade }
    end
  end
end
