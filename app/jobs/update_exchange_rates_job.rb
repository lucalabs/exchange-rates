class UpdateExchangeRatesJob < ActiveJob::Base
  def perform
    eu_bank = EuCentralBank.new
    eu_bank.update_rates

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
      rate = fetch_rate(eu_bank: eu_bank, open_bank: open_bank, rate_name: rate_name)

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
  end

  def fetch_rate(eu_bank:, open_bank:, rate_name:)
    begin
      eu_bank.get_rate('EUR', 'NOK') / eu_bank.get_rate('EUR', rate_name.to_s.upcase!)
    rescue => _e # Happens on unknown currency, let's use open_bank if available
      if open_bank.nil?
        1
      else
        begin
          eu_bank.get_rate('EUR', 'NOK') / open_bank.get_rate('EUR', rate_name.to_s.upcase!)
        rescue => _e
          1
        end
      end
    end
  end
end