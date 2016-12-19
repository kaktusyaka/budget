class CreateSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_categories do |t|
      t.belongs_to :category, index: true
      t.string :name
      t.timestamps
    end
  end
end
