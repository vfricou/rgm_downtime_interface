require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RgmDowntimeInterface
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Autoload lib/ folder including all subdirectories
    config.eager_load_paths << Rails.root.join('lib')

    # Load custom configurations
    config.rgmdwt = config_for(:rgmdwt)

    # Set locale
    I18n.available_locales = %i[en fr]
    I18n.default_locale = :fr

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
