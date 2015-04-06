class Agent < ActiveRecord::Base
  has_many :agent_deals
  has_many :deals, through: :agent_deals

  def buy(deal)
    self.balance -= deal.open_price
    self.deals << deal
    self.save
  end

  def sell(deal)
    self.balance += deal.close_price
    self.deals.delete deal
    puts "current balance: #{self.balance}"
    self.save
  end

  def trade(buy_deal, sell_deal)
    buy buy_deal
    sell sell_deal
    self.save
  end
end
