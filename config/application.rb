require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Curriculr
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # By Curriculr
    config.active_record.raise_in_transactional_callbacks = true
    ###config.active_job.queue_adapter = :sidekiq

    # Initialize redis and load application configuration
    config.redis_databases = {
      "development" => 0,
      "test" => 1,
      "production" => 2
    }

    if Rails.application.secrets.redis_enabled
      $redis = Redis.new(db: config.redis_databases[Rails.env.to_s])
    else
      require "redis_decoy"
      $redis = RedisDecoy.new(db: config.redis_databases[Rails.env.to_s])
    end

    if $redis.exists('config.site')
      config.site = JSON.parse($redis.get('config.site'))
    else
      config.site = YAML.load_file("#{Rails.root}/config/config-site.yml")['site']
      $redis.set 'config.site', config.site.to_json
    end

    $site = config.site

    config.site_engines = {}

    config.time_zone = config.site['time_zone']
    config.i18n.default_locale = config.site['locale']

    config.exceptions_app = self.routes

    require "current_account"
    config.middleware.use CurrentAccount, Rails.application.secrets.site['domain']
  end
end
