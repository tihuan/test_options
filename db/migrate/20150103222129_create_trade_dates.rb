class CreateTradeDates < ActiveRecord::Migration
  def change
    create_table :trade_dates do |t|

      t.timestamps null: false
    end
  end
end
