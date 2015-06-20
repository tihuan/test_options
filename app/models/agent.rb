class Agent < ActiveRecord::Base
  has_many :agent_deals
  has_many :deals, through: :agent_deals

  def initiate
    @report = Report.create
  end

  def buy(deal)
    self.balance -= deal.open_price
    self.deals << deal
    puts '-' * 10
    puts 'buying deal:'
    puts '-' * 10
    puts "due date: #{deal.due_date} @open_price: #{deal.open_price}"
    puts "current balance: #{self.balance}"
    self.save
  end

  def sell(deal)
    self.balance += deal.close_price
    reference_deal = self.deals.find_by(due_date: deal.due_date).delete
    puts '-' * 10
    puts 'selling deal:'
    puts '-' * 10
    puts "due date: #{deal.due_date} @close_price: #{deal.close_price}"
    puts "current balance: #{self.balance}"
    self.save
  end

  def trade(buy_deal, sell_deal)
    buy buy_deal
    sell sell_deal
    puts '_' * 20
    puts ''
    self.save
  end
end
