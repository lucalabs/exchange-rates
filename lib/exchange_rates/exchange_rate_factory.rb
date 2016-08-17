module ExchangeRates
  class ExchangeRateFactory
    def rate_close_to(before = Date.today)
      ExchangeRate.rate_close_to(before)
    end
  end
end