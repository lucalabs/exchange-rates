class AddAdditionalCurrencies < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :jpy, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :bgn, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :czk, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :dkk, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :gbp, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :huf, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :pln, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :ron, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :sek, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :chf, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :hrk, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :rub, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :try, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :aud, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :brl, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :cad, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :cny, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :hkd, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :idr, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :ils, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :inr, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :krw, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :mxn, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :myr, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :nzd, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :php, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :sgd, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :thb, :decimal, precision: 9, scale: 6
    add_column :exchange_rates, :zar, :decimal, precision: 9, scale: 6
  end
end