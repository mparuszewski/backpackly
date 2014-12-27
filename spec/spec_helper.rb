ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  config.filter_run_excluding not_implemented: true
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec do |c|
    c.syntax = [:expect]
  end
end