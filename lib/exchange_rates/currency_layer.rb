require 'rest-client'
require 'json'

module ExchangeRates
  class CurrencyLayer

    API_BASE = 'http://apilayer.net/api'.freeze
    SOURCE_CURRENCY = 'USD'.freeze # Our current plan only supports USD as source

    def historical_data(date, source = SOURCE_CURRENCY)
      response = build_request 'historical', {date: date,
                                              currencies: ExchangeRate.available_rates_params,
                                              source: SOURCE_CURRENCY}
      parse_quotes response
    end

    private

    def parse_quotes(response)
      quotes = JSON.parse(response.body)['quotes']
      raise 'Failed to parse response: ' + response.body.to_yaml if quotes.nil?
      convert_quotes_to_nok quotes
    end

    def convert_quotes_to_nok(quotes)
      nok_quote = quotes['USDNOK']

      quotes.each {|key, val| quotes[key] = nok_quote / val}
      quotes.select{|quote| quote != 'USDNOK'}
    end

    def build_request(path, args = {})
      RestClient.get "#{API_BASE}/#{path}", params_with_access_key(args)
    end

    def params_with_access_key(args)
      raise 'Missing environment variable: CURRENCYLAYER_API_KEY' unless ENV.has_key? 'CURRENCYLAYER_API_KEY'
      {params: args.merge({access_key: ENV['CURRENCYLAYER_API_KEY']})}
    end
  end
end
