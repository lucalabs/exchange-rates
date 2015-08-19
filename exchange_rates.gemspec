# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'exchange_rates'
  s.version     = '0.1.2'
  s.summary     = 'Adds exchange rates to spree'
  s.description = 'Adds exchange rates to spree'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Erik Axel Nielsen'
  s.email     = 'erikaxel.nielsen@gmail.com'
  s.homepage  = 'http://www.example.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'money', '>= 6.0.0'
  s.add_dependency 'eu_central_bank', '>= 0.4.0'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.3'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
