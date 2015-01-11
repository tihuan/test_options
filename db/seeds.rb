require 'CSV'

ActiveRecord::Base.transaction do
  months = [
    'february',
    'may',
    'august',
    'november'
  ]

  years = (1998..2013).to_a

  def trade_dates(year)
    months = [
      'february',
      'may',
      'august',
      'november'
    ]

    months.map { |month| chronic_date = Chronic.parse("3rd wednesday in #{month}", now: Time.local(year)) }
  end

  trade_dates = years.map { |year| trade_dates(year) }.flatten
  formatted_trade_dates = trade_dates.map { |trade_date| trade_date.strftime('%m/%d/%Y') }

  puts "all trade dates\n\n\n\n"
  p formatted_trade_dates
  p trade_dates.size

  all_deals = CSV.read 'all_deals.csv'

  formatted_trade_dates.each do |trade_date|

    trade_date = trade_date.to_date
    new_trade_date = TradeDate.create(trade_date: trade_date)
    monthly_deals = all_deals.select { |deal| deal[0] == trade_date }
    puts "monthly_deals HERE \n\n\n\n"
    # p monthly_deals
    monthly_deals[0] << 'this_month'
    monthly_deals[1] << 'next_month'
    monthly_deals[2] << 'season_1'
    monthly_deals[3] << 'season_2'
    monthly_deals[4] << 'season_3'

    monthly_deals.each do |monthly_deal|
      formatted_due_date = monthly_deal[2].gsub(/(\d{4})(\d{2})/, '\2/01/\1')
      date = Date.strptime(monthly_deal[0],'%m/%d/%Y')
      due_date = Date.strptime(formatted_due_date, '%m/%d/%Y')
      open_price = monthly_deal[3].to_i
      deal_price = monthly_deal[6].to_i
      due_type = monthly_deal[-1]

      deal = Deal.create(due_date: due_date, open_price: open_price, deal_price: deal_price, due_type: due_type)
      new_trade_date.deals << deal
    end
  end
end
