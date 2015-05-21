require 'CSV'
require 'pry'

task :sanitize => :environment do |t|
  HEADERS = %w(date  category  due_date  open_price  max_price min_price close_price volume  final_price)
  ALL_PRICES = %w(open_price  max_price min_price close_price)
  @updated_deals = []

  def fill_prices
    all_deals = CSV.foreach('test.csv', headers: true) do |deal|
      if deal['open_price'] == '-'
        ALL_PRICES.each do |header|
          deal[header] = deal['final_price']
        end
      end
      @updated_deals << deal
    end
  end

  def find_missing_days
    all_deals = CSV.read('test.csv', headers: true)
    currently_available_days = all_deals['date'].uniq
    first_day = DateTime.strptime('7/21/1998', '%m/%d/%Y')
    end_of_last_year = DateTime.strptime("12/31/#{Time.now.year - 1}", '%m/%d/%Y')
    days = (first_day..end_of_last_year).step(1).to_a.map { |day| day.strftime('%m/%d/%Y') }

    days - currently_available_days
  end

  def fill_missing_day_data(missing_day, missing_days)
    missing_day = DateTime.strptime(missing_day, '%m/%d/%Y')
    new_deals = []
    next_trade_day = missing_day.tomorrow
    next_trade_day = next_trade_day.tomorrow while missing_days.include? next_trade_day.strftime('%m/%d/%Y')
    next_trade_day_deals = @updated_deals.select { |deal| deal['date'] == next_trade_day.strftime('%m/%d/%Y') }.dup

    next_trade_day_deals.each { |deal| deal.dup['date'] = missing_day.strftime('%m/%d/%Y') }
  end

  def write_file
    CSV.open('updated_test.csv', 'w') do |csv|
      csv << HEADERS
      @updated_deals.each do |updated_deal|
        csv.puts updated_deal
      end
    end
  end

  # binding.pry
  fill_prices
  missing_days = find_missing_days
  missing_days_data = missing_days[0..2].map { |missing_day| fill_missing_day_data(missing_day, missing_days) }
  @updated_deals.concat(missing_days_data).flatten!
  write_file
  # binding.pry
end
