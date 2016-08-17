# This seems to be slower, so it is not used right now
module ExchangeRates
  class ExchangeRateCachedFactory
    attr_accessor :rates, :cache

    def initialize(cache_from_date)
      @rates = ExchangeRate.where('rate_date >= ?', cache_from_date)
      @cache = Hash[@rates.collect { |rate| [rate.rate_date.strftime('%Y-%m-%d'), rate] }]

      rate_orig_size = @cache.size

      # Cache the first rate
      previous_rate = ExchangeRate.rate_close_to(cache_from_date)

      #   Create dates we don't have, we dont expect it to be many
      (cache_from_date..Date.today).each do |date|
        rate = @cache[date.strftime('%Y-%m-%d')]
        if rate.nil?
          @cache[date.strftime('%Y-%m-%d')] = previous_rate
          Rails.logger.debug "didnt find for date #{date.strftime('%Y-%m-%d')}"
        else
          previous_rate = rate
        end
      end

      Rails.logger.debug "Found #{rate_orig_size} rates, after filling #{@cache.size}"
    end

    def rate_close_to(before = Date.today)
      @cache[before.strftime('%Y-%m-%d')]
    end
  end
end