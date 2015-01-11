class AddPropertiesToTradeDate < ActiveRecord::Migration
  def change
    change_table :trade_dates do |t|
      t.date :trade_date
    end
  end
end
