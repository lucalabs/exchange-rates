namespace :exchange_rate do
  desc 'Update exchange rate'
  task fetch_today: :environment do
    UpdateExchangeRatesJob.perform_now
  end

  # rake 'exchange_rate:fetch_historic[2020, weekly]' or rake 'exchange_rate:fetch_historic[2020]'
  # default `weekly`
  desc 'Updates exchange rates table with rates from the provided year'
  task :fetch_historic, [:year, :step] => :environment do |t, args|
    year = args[:year].to_i
    step = args[:step].to_s.presence || 'weekly'

    UpdateHistoricalRatesExchangeRatesJob.perform_now(year: year, step: step)
  end
end
