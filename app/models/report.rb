# 1. Add map for headers and print row
class Report < ActiveRecord::Base
  belongs_to :agent
  has_many :reports_deals
  has_many :deals, through: :reports_deals

  after_initialize :set_rows, :set_header_indices

  def read_rows
    @rows
  end

  def add_hi
    @rows << 'hi'
  end



  private

  def set_rows
    @rows = JSON.parse print_rows
  end

  def set_header_indices
    headers = @rows.first
    @header_indices = headers.each_with_index.each_with_object({}) do |header_index_pair, memo|
      header, index = header_index_pair
      memo[header.to_sym] = index
    end
  end
end
