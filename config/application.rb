require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module Backpackly
  class Application < Rails::Application
    config.autoload_paths += Dir[Rails.root.join('lib', '{**/}')]
    config.encoding = 'utf-8'
    config.active_support.escape_html_entities_in_json = true
    config.filter_parameters += [:password]

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false
    config.action_controller.include_all_helpers = false

    ForecastIO.api_key = '87bd127d3c46bf1c5c8900a6f62695d9'
  end
end
