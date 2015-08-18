class CreateExchangeRate < ActiveRecord::Migration
  def change
    create_table 'exchange_rates', force: true do |t|
      t.date 'rate_date'
      t.decimal  'eur',        precision: 9, scale: 6
      t.decimal  'usd',        precision: 9, scale: 6
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    add_index 'exchange_rates', ['rate_date'], name: 'index_exchange_rates_on_rate_date'
  end
end
