# 1. Add map for headers and print row
class Report < ActiveRecord::Base
  belongs_to :agent
  has_many :report_rows

  def print_trade_date_deals(trade_date)

  end

  def add(args = {})
    headers = rows.first
    binding.pry
    report_row = ReportRow.create headers
    report_row.update args

    report_rows << report_row
  end
end
