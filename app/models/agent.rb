class Agent < ActiveRecord::Base
  has_many :agent_deals, autosave: true
  has_many :deals, through: :agent_deals
  has_many :reports

  def buy(deal)
    agent_deals.create(
      bought_date: deal.trade_date.trade_date,
      deal: deal,
      cost: deal.open_price
    )
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
      due_date: 100,
      trade_date: deal.trade_date.trade_date,
      buy_due_date: deal.due_date,
      buy_price: deal.open_price,
      cash: self.balance,
      total:  self.balance + all_deal_cost
    }

    puts "\n\n\n\n"
    p buy_details

    last_report.add buy_details
    print_inventory deal.trade_date.trade_date

    self.save
  end

  def sell(deal)
    self.balance += deal.close_price
    reference_deal = deals.find_by(due_date: deal.due_date)

    sell_price = deal.close_price
    agent_deal = AgentDeal.find_by(deal_id: reference_deal)
    cost = agent_deal.cost
    net_gain = sell_price - cost

    agent_deals.update(
      agent_deal.id,
      net_gain: net_gain,
      sold_date: deal.trade_date.trade_date
    )

    puts '-' * 10
    puts 'AGENT DEAL'
    p agent_deal
    puts "\n\n\n\n"

    puts '-' * 10
    puts 'selling deal:'
    puts '-' * 10
    puts "due date: #{deal.due_date} @close_price: #{deal.close_price}"
    puts "current balance: #{balance}"
    puts "all deal cost: #{all_deal_cost}"

    sell_details = {
      due_date: 200,
      trade_date: deal.trade_date.trade_date,
      sell_due_date: deal.due_date,
      sell_price: sell_price,
      deal_min_price: deal.min_price,
      cash: self.balance,
      total:  self.balance + all_deal_cost,
      net_gain: net_gain,
      total_net_gain: total_net_gain
    }

    puts "\n\n\n\n"
    p sell_details

    last_report.add sell_details

    self.save
  end

  def trade(buy_deal, sell_deal)
    last_report.print_all_deals buy_deal.trade_date.deals
    buy buy_deal
    sell sell_deal
    puts '_' * 20
    puts ''
    self.save
  end

  private

  def print_inventory(trade_date)
    agent_deals.reload
    agent_deals
      .reject { |agent_deal| agent_deal.sold_date.present? }
      .each_with_index do |agent_deal, index|
        deal_detail = {
          trade_date: trade_date,
          due_date: 101 + index,
          all_deals_due_date: agent_deal.deal.due_date,
          all_deals_buy_price: agent_deal.cost
        }
        last_report.add deal_detail
      end

    summary = {
      trade_date: trade_date,
      due_date: 199,
      deals_total_value: all_deal_cost,
      cash: balance,
      total: all_deal_cost + balance
    }

    last_report.add summary
  end

  def all_deal_cost
    agent_deals.reload
    agent_deals
      .reject { |agent_deal| agent_deal.sold_date.present? }
      .map(&:cost)
      .reduce(:+)
  end

  def total_net_gain
    agent_deals.reload
    agent_deals
      .map(&:net_gain)
      .reduce(&:+)
  end

  def last_report
    reports.last
  end
end
