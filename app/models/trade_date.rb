class TradeDate < ActiveRecord::Base
  has_many :deals

  def get_deal(due_type)
    deal = deals.find_by(due_type: due_type)
    raise "due type: #{due_type} is not a known type" unless deal
    deal
  end
end
