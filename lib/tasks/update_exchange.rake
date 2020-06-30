namespace :exchange_rate do
  desc 'Update exchange rate'
  task fetch_today: :environment do
    require 'money'
    require 'eu_central_bank'
    require 'money/bank/open_exchange_rates_bank'

    eu_bank = EuCentralBank.new; eu_bank.update_rates

    if ENV['OPEN_EXCHANGE_API_KEY'].present?
      open_bank = Money::Bank::OpenExchangeRatesBank.new
      open_bank.app_id = ENV['OPEN_EXCHANGE_API_KEY']
      open_bank.update_rates
    else
      Rails.logger.warn("OPEN_EXCHANGE_API_KEY not set, can not use Open Exchange to update exchange rates")
      open_bank = nil
    end

    current = ExchangeRate.find_by_rate_date(Date.today)
    if current.nil?
      current = ExchangeRate.new
      current.rate_date = Date.today
    end

    ExchangeRate.available_rates.select { |rate| rate != :nok }.each do |rate_name|
      # rate = Money.default_bank.exchange(10000, rate.to_s, 'NOK').cents / 10000.0
      begin
        rate = eu_bank.get_rate('EUR', 'NOK') / eu_bank.get_rate('EUR', rate_name.to_s.upcase!)
      rescue
        rate = if open_bank.nil?
                 1
               else
                 eu_bank.get_rate('EUR', 'NOK') / open_bank.get_rate('EUR', rate_name.to_s.upcase!)
               end
      end

      number_parts = rate.to_s.split('.')
      if number_parts.first.size <= ExchangeRate::PRECISION - ExchangeRate::SCALE
        current.send("#{rate_name}=", rate)
      else
        @errors ||= {}
        @errors[rate_name] = rate.to_s
      end
    end
    current.save!

    puts 'Updated exchange rate table'

    puts "WARNING: Values wasn't saved. Too big values in: #{@errors}" if @errors
    # puts TurnkeyUpdater.send_data({items: [{label:'eur', value: '%.4f' % current.eur}, {label:'usd',value:'%.4f' % current.usd}]}, 'currency')
  end

  # rake 'exchange_rate:fetch_historic[2020, weekly]' or rake 'exchange_rate:fetch_historic[2020]'
  # default `weekly`
  desc 'Updates exchange rates table with rates from the provided year'
  task :fetch_historic, [:year, :step] => :environment do |t, args|
    require 'money'
    require 'money/bank/open_exchange_rates_bank'

    if ENV['OPEN_EXCHANGE_API_KEY'].empty?
      Rails.logger.warn("OPEN_EXCHANGE_API_KEY not set, can not use Open Exchange to update exchange rates")
      return
    end

    year = args[:year].to_i
    step = args[:step].to_s.presence || 'weekly'
    start_date = Date.new(year, 01, 01)
    end_date = Time.now < Date.new(year, 12, 31) ? Time.now.to_date : Date.new(year, 12, 31)

    enumerator = case step
                 when 'daily'
                   (start_date..end_date)
                 when 'weekly'
                   (start_date..end_date).step(7)
                 end
    month = nil

    # For each day or each day or week in year
    enumerator.each do |date|
      # Initializing bank
      open_bank = Money::Bank::OpenExchangeRatesBank.new
      open_bank.app_id = ENV['OPEN_EXCHANGE_API_KEY']
      open_bank.date = date
      open_bank.update_rates

      # Select exchange rate or initialize new for this date
      current = ExchangeRate.find_by_rate_date(date)
      if current.nil?
        current = ExchangeRate.new
        current.rate_date = date
      end

      # Progress info
      if date.strftime("%B") != month
        month = date.strftime("%B")
        puts "Working for #{month}"
      end

      # Saving rates for each currency
      ExchangeRate.available_rates.select { |rate| rate != :nok }.each do |rate_name|
        rate = open_bank.get_rate(rate_name.to_s.upcase!, 'NOK') || 1

        # Handling cases when received number is bigger than we can store in the db
        number_parts = rate.to_s.split('.')
        if number_parts.first.size <= ExchangeRate::PRECISION - ExchangeRate::SCALE
          current.send("#{rate_name}=", rate)
        else
          @errors ||= {}
          @errors[rate_name] = rate.to_s
        end
      end
      current.save!
    end

    puts 'Updated exchange rate table'

    puts "WARNING: Values wasn't saved. Too big values in: #{@errors}" if @errors
  end
end
