# 1. Add map for headers and print row
class Report < ActiveRecord::Base
  belongs_to :agent
  after_initialize :set_rows, :set_header_indices
  attr_accessor :rows

  def read_rows
    rows
  end

  def print_trade_date_deals(trade_date)

  end

  def add_row(args = {})
    headers =rows.first
    col_counts = headers.count
    row = Array.new(col_counts, '')
    args.each do |key, value|
      index = @header_indices[key]
      row[index] = value
    end
    rows << row
  end

  private

  def set_rows
    @rows = JSON.parse print_rows
  end

  def set_header_indices
    headers = rows.first
    @header_indices = headers.each_with_index.each_with_object({}) do |header_index_pair, memo|
      header, index = header_index_pair
      memo[header.to_sym] = index
    end
  end
end
