# Be sure to restart your server when you modify this file
# Specifies gem version of Rails to use when vendor/rails is not present
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|
  config.gem 'will_paginate', :version => '~> 2.3.16'
  config.gem 'russian'
  config.gem 'haml'
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = :order_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Moscow'

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {:host => 'localhost:3000'}

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.i18n.default_locale = :ru

  config.load_paths << "#{RAILS_ROOT}/app/filters"
end

CalendarDateSelect.format = :finnish
File.join('./','tmp','debug.txt')