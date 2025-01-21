class UpdateHistoricalRatesExchangeRatesJob < ActiveJob::Base
  def perform(year:, step:)

    if ENV['OPEN_EXCHANGE_API_KEY'].empty?
      Rails.logger.warn("OPEN_EXCHANGE_API_KEY not set, can not use Open Exchange to update exchange rates")
      return
    end

    start_date = Date.new(year, 01, 01)
    end_date = Date.current < Date.new(year, 12, 31) ? Date.current : Date.new(year, 12, 31)

    enumerator = case step
                 when 'daily'
                   (start_date..end_date)
                 when 'weekly'
                   (start_date..end_date).step(7)
                 else
                   raise "Unknown step: #{step}"
                 end
    month = nil

    open_bank = Money::Bank::OpenExchangeRatesBank.new
    open_bank.app_id = ENV['OPEN_EXCHANGE_API_KEY']

    # For each day or each day or week in year
    enumerator.each do |date|
      # Initializing bank
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