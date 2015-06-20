require 'CSV'
require 'pry'
# MAKE SURE all_deals.csv date format is mm/dd/yyyy

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
    puts "\n\n\n\nINSIDE #create_deals, daily_deals"
    p daily_deals

    trade_date = Date.strptime(daily_deals.first[0], '%m/%d/%Y')
    puts "\n\n\nTRADE DATE"
    p trade_date

    new_trade_date = TradeDate.create(trade_date: trade_date)
    # tagging deal due type
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
      max_price = deal[4].to_i
      min_price = deal[5].to_i
      close_price = deal[6].to_i
      final_price = deal[-2].to_i
      due_type = deal[-1]

      deal = Deal.create(
        due_date: due_date,
        open_price: open_price,
        max_price: max_price,
        min_price: min_price,
        close_price: close_price,
        final_price: final_price,
        due_type: due_type)
      new_trade_date.deals << deal
    end
  end

  years = (1998..2014).to_a
  trade_dates = years.map { |year| trade_dates(year) }.flatten

  formatted_trade_dates = trade_dates.map { |trade_date| trade_date.strftime('%m/%d/%Y') }
  puts "\n\n\n\n\n\n\nFORMATTED TRADE DATES:"
  p formatted_trade_dates

  all_deals = CSV.read 'updated_all_deals.csv'
  puts "\n\n\n\n\n\n\nALL DEALS:"
  p all_deals

  # filtered_deals = all_deals.select { |deal| formatted_trade_dates.include? deal.first }.in_groups_of(5, false)

  # filtered_deals = all_deals.select do |deal|
  #   formatted_trade_dates.include? deal.first
  # end.in_groups_of(5, false)

  formatted_trade_dates.each do |trade_date|
    filtered_deals = all_deals.select { |deal| deal.first == trade_date }
    date = Date.strptime(trade_date, '%m/%d/%Y')

    until filtered_deals.any?
      puts "\n\n\nfinding new date"
      date = date.tomorrow
      trade_date = date.strftime('%m/%d/%Y')
      filtered_deals = all_deals.select { |deal| deal.first == trade_date }
    end

    puts "\n\n FILTERED DEALS HERE:"
    p filtered_deals
    create_deals filtered_deals
    # filtered_deals.each do |daily_deal|
      # create_deals daily_deal
    # end
  end
end
