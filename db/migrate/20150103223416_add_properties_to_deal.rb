class AddPropertiesToDeal < ActiveRecord::Migration
  def change
    change_table :deals do |t|
      t.belongs_to :trade_date, index: true
      t.date :due_date
      t.integer :open_price
      t.integer :close_price
      t.integer :final_price
      t.string :due_type
    end
  end
end
