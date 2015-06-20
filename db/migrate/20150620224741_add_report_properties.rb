class AddReportProperties < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.belongs_to :agent, index: true
      t.string :headers, default: %w(
        due_date
        open_price
        min_price
        close_price
        final_price
        -
        buy_due_date
        buy_price
        -
        sell_due_date
        sell_price
        -
        all_deals_due_date
        all_deals_buy_price
        deals_total_value
        net_gain
        -
        total_net_gain
        cash
        total
        -
        deal_min_price
        period_min_price
        diff_deal_period_min_price).join(',')
    end
  end
end
