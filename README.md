Exchange Rates
=================

Introduction goes here.

Installation
------------

Add exchange_rate to your Gemfile:

```ruby
gem 'exchange_rate'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g exchange_rates:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rspec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'exchange_rate/factories'
```

Copyright (c) 2015 Erik Axel Nielsen
