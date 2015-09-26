# 1. Add map for headers and print row
class Report < ActiveRecord::Base
  belongs_to :agent
  has_many :report_rows

  def print_trade_date_deals(trade_date)

  end

  def add(args = {})
    report_row = ReportRow.create
    report_row.update args

    report_rows << report_row
  end

  def print_all_deals(all_deals)
    all_deals.each do |deal|
      deal_details = {
        trade_date: deal.trade_date.trade_date,
        due_date: deal.due_date,
        open_price: deal.open_price,
        min_price: deal.min_price,
        close_price: deal.close_price,
        final_price: deal.final_price
      }
      add deal_details
    end
  end
end
