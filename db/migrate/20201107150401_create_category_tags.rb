# frozen_string_literal:true

class CreateCategoryTags < ActiveRecord::Migration[5.2]
  def change
    create_table :category_tags do |t|
      t.belongs_to :category, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end
  end
end
