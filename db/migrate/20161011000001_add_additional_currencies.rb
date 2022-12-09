class AddAdditionalCurrencies < ActiveRecord::Migration
  def change
    (ExchangeRate.available_rates - [:nok]).each do |currency|
      add_column :exchange_rates, currency, :decimal, precision: ExchangeRate::PRECISION, scale: ExchangeRate::SCALE
    end
  end
end