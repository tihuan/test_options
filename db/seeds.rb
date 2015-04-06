# MAKE SURE all_deals.csv date format is mm/dd/yyyy
require 'CSV'
require 'pry'

ActiveRecord::Base.transaction do
  def trade_dates(year)
    # months = %w(
    #   january
    #   february
    #   march
    #   april
    #   may
    #   june
    #   july
    #   august
    #   september
    #   october
    #   november
    #   december)
    months = [
      'february',
      'may',
      'august',
      'november'
    ]

    months.map { |month| chronic_date = Chronic.parse("3rd wednesday in #{month}", now: Time.local(year)) }
  end

  def create_deals(daily_deals)
    trade_date = Date.strptime(daily_deals.first[0], '%m/%d/%Y')
    new_trade_date = TradeDate.create(trade_date: trade_date)
    # each daily_deals has 5 records corresponding to the deal_type
    daily_deals[0] << 'this_month'
    daily_deals[1] << 'next_month'
    daily_deals[2] << 'season_1'
    daily_deals[3] << 'season_2'
    daily_deals[4] << 'season_3'

    daily_deals.each do |deal|
      formatted_due_date = deal[2].gsub(/(\d{4})(\d{2})/, '\2/01/\1')
      date = Date.strptime(deal[0],'%m/%d/%Y')
      due_date = Date.strptime(formatted_due_date, '%m/%d/%Y')
      open_price = deal[3].to_i
      close_price = deal[6].to_i
      due_type = deal[-1]

      deal = Deal.create(due_date: due_date, open_price: open_price, close_price: close_price, due_type: due_type)
      new_trade_date.deals << deal
    end
  end

  years = (1998..2014).to_a
  trade_dates = years.map { |year| trade_dates(year) }.flatten
  formatted_trade_dates = trade_dates.map { |trade_date| trade_date.strftime('%m/%d/%Y') }
  p formatted_trade_dates
  all_deals = CSV.read 'all_deals.csv'
  p all_deals
  # filtered_deals = all_deals.select { |deal| formatted_trade_dates.include? deal.first }.in_groups_of(5, false)
  filtered_deals = all_deals.select do |deal|
    formatted_trade_dates.include? deal.first
  end.in_groups_of(5, false)




  p filtered_deals
  filtered_deals.each do |daily_deal|
    create_deals daily_deal
  end
end
