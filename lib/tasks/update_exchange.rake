desc 'Update exchange rate'
task update_exchange_rate: :environment do
  require 'money'
  require 'eu_central_bank'

  Money.default_bank = EuCentralBank.new
  Money.default_bank.update_rates

  current = ExchangeRate.find_by_rate_date(Date.today)
  if current.nil?
    current = ExchangeRate.new
    current.rate_date = Date.today
  end
  current.eur = Money.default_bank.exchange(10000, 'EUR', 'NOK').cents / 10000.0
  current.usd = Money.default_bank.exchange(10000, 'USD', 'NOK').cents / 10000.0
  current.save!

  puts 'Updated exchange rate table'
  # puts TurnkeyUpdater.send_data({items: [{label:'eur', value: '%.4f' % current.eur}, {label:'usd',value:'%.4f' % current.usd}]}, 'currency')
end
