require 'pry'

# rake trade\['season_3','season_2'\]
# rake trade\['season_3','season_2'\] --trace

desc 'Run trading simulation with different due types strategy: Please provide, buy due type and sell due type as string'
task :trade, [:buy_due_type, :sell_due_type] => :environment do |t, args|
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
    months = %w(
      february
      may
      august
      november
    )

    months.map { |month| chronic_date = Chronic.parse("3rd wednesday in #{month}", now: Time.local(year)).to_date }
  end

  a = Agent.create
  r = Report.create
  a.reports << r
  # years = [2007]
  years = (1998..2013).to_a
  trade_dates = years.map { |year| trade_dates(year) }.flatten
  # formatted_trade_dates = trade_dates.map { |trade_date| trade_date.strftime('%m/%d/%Y') }
  sorted_trade_dates = TradeDate.order :trade_date
  # first_available_trade_date = TradeDate.find_by(trade_date: Date.strptime('2/21/2007', '%m/%d/%Y'))
  first_available_trade_date = TradeDate.find_by(trade_date: Date.strptime('8/19/1998', '%m/%d/%Y'))
  first_available_trade_date_index = sorted_trade_dates.index first_available_trade_date
  # binding.pry
  effective_trade_dates = sorted_trade_dates[first_available_trade_date_index..-1]
  # first record is 8/19/1998, but first trade date is 7/21/1998..
  first_trade_date = effective_trade_dates.shift
  r.print_all_deals first_trade_date.deals
  p "Starting balance: #{a.balance}"
  a.buy first_trade_date.get_deal args[:buy_due_type]

  effective_trade_dates.each do |trade_date|
    p "trade date: #{trade_date.trade_date}"
    a.trade(trade_date.get_deal(args[:buy_due_type]), trade_date.get_deal(args[:sell_due_type]))
  end

  p "here's your result:"
  p a.balance

  # Output excel
  lines = r.report_rows.map { |row| JSON.parse(row.content)  }
  CSV.open('trade_result.csv', 'w') do |csv|
    csv << JSON.parse(r.report_rows.first.headers)
    lines.each do |line|
      csv.puts line
    end
  end
end
