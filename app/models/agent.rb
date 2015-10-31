class Agent < ActiveRecord::Base
  has_many :agent_deals
  has_many :deals, through: :agent_deals
  has_many :reports

  def buy(deal)
    agent_deals.create(deal: deal, cost: deal.open_price)
    # ad = AgentDeal.new
    # ad.agent = self
    # ad.deal = deal
    # ad.cost = deal.open_price
    # ad.save

    self.balance -= deal.open_price
    puts '-' * 10
    puts 'buying deal:'
    puts '-' * 10
    puts "due date: #{deal.due_date} @open_price: #{deal.open_price}"
    puts "current balance: #{self.balance}"
    puts "all deal cost: #{all_deal_cost}"

    buy_details = {
      trade_date: deal.trade_date.trade_date,
      buy_due_date: deal.due_date,
      buy_price: deal.open_price,
      cash: self.balance,
      total:  self.balance + all_deal_cost
    }

    puts "\n\n\n\n"
    p buy_details

    last_report.add buy_details

    self.save
  end

  def sell(deal)
    self.balance += deal.close_price
    reference_deal = self.deals.find_by(due_date: deal.due_date)
    deals.delete reference_deal
    puts '-' * 10
    puts 'selling deal:'
    puts '-' * 10
    puts "due date: #{deal.due_date} @close_price: #{deal.close_price}"
    puts "current balance: #{self.balance}"
    puts "all deal cost: #{all_deal_cost}"

    sell_details = {
      trade_date: deal.trade_date.trade_date,
      sell_due_date: deal.due_date,
      sell_price: deal.close_price,
      cash: self.balance,
      total:  self.balance + all_deal_cost
    }

    puts "\n\n\n\n"
    p sell_details

    last_report.add sell_details

    self.save
  end

  def trade(buy_deal, sell_deal)
    buy buy_deal
    sell sell_deal
    puts '_' * 20
    puts ''
    self.save
  end

  private

  def all_deal_cost
    agent_deals.map(&:cost).reduce(:+)
  end

  def last_report
    reports.last
  end
end
