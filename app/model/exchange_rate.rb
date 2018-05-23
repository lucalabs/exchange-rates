class ExchangeRate < ActiveRecord::Base
  scope :rate_close_to, -> (before = Date.today, limit = 1) do
    before ||= Date.today
    where('rate_date <= ?', before).order('rate_date DESC').limit(limit)
  end

  def self.available_rates
    [:nok, :eur, :usd, :jpy, :bgn, :czk, :dkk, :gbp, :huf,
     :pln, :ron, :sek, :chf, :hrk, :rub, :try, :aud, :brl,
     :cad, :cny, :hkd, :idr, :ils, :inr, :krw, :mxn, :myr,
     :nzd, :php, :sgd, :thb, :zar, :isk]
  end

  def self.available_rates_params
    available_rates
        .map(&:to_s)
        .join(',')
  end

  def nok
    1.0
  end

  def rate(string)
    return nil if string.nil?
    method = string.downcase.to_s
    return nil unless self.respond_to?(method.to_sym)
    send(method)
  end

  def nok_to_eur(nok_value)
    nok_value / eur
  end

  def eur_to_nok(eur_value)
    eur_value * eur
  end
end
