desc 'Update exchange rate'
task update_exchange_rate: :environment do
  require 'money'
  require 'eu_central_bank'

  Money.default_bank = EuCentralBank.new
  Money.default_bank.update_rates

  current = ExchangeRate.find_by_rate_date(Date.today)
  if current.nil?
    current = ExchangeRate.new
    current.rate_date = Date.today
  end

  ExchangeRate.available_rates.select { |rate| rate != :nok }.each do |rate_name|
    # rate = Money.default_bank.exchange(10000, rate.to_s, 'NOK').cents / 10000.0
    rate = Money.default_bank.get_rate('EUR', 'NOK') / Money.default_bank.get_rate('EUR', rate_name.to_s)
    current.send("#{rate_name}=", rate)

  end
  current.save!

  puts 'Updated exchange rate table'
  # puts TurnkeyUpdater.send_data({items: [{label:'eur', value: '%.4f' % current.eur}, {label:'usd',value:'%.4f' % current.usd}]}, 'currency')
end

desc 'Updates exchange rates table with rates from the provided year'
task :weekly_rates_by_year, [:year] => :environment do |t, args|
  year = args[:year].to_i
  start_date = Date.new(year, 01, 01)
  end_date = Time.now < Date.new(year, 12, 31) ? Time.now.to_date : Date.new(year, 12, 31)

  ActiveRecord::Base.transaction do

    (0..52).each do |week|
      date = start_date + week * 7

      break if date > end_date

      puts "Fetching quotes for #{date.to_s} ..."
      rate = ExchangeRate.find_by_rate_date(date) || ExchangeRate.new(rate_date: date)
      quotes = ExchangeRates::CurrencyLayer.new.historical_data(date)
      quotes.each do |key, quote|
        rate.send("#{key.sub('USD', '').downcase}=", BigDecimal.new(quote, 6))
      end

      rate.save!
    end

    puts 'Updated exchange rate table'
  end
end
