# 1. Add map for headers and print row
class Report < ActiveRecord::Base
  belongs_to :agent
  has_many :reports_deals
  has_many :deals, through: :reports_deals

  after_initialize :set_rows

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
end
