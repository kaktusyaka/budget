class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :category, index: true
      t.boolean :income, default: false
      t.date :date
      t.decimal :amount, precision: 11, scale: 2
      t.text :description

      t.timestamps null: false
    end
  end
end
