# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

# Coverage
require 'simplecov'
SimpleCov.start

require 'simplecov-cobertura'
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

# Load lib
require_relative '../lib/deepl'
require_relative 'integration_tests/integration_test_utils'

# Auto-load test helpers under spec/support
Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f }

# Lib config
ENV['DEEPL_AUTH_KEY'] ||= 'TEST-TOKEN'

RSpec.configure do |config|
  config.include ManagedGlossary
  config.include ManagedStyleRule
  config.include ManagedTranslationMemory

  config.before(:each, :mock_server_only) do
    skip 'Only runs on mock server' unless ENV.key?('DEEPL_MOCK_SERVER_PORT')
  end

  config.before(:each, :real_server_only) do
    skip 'Only runs on real server' if ENV.key?('DEEPL_MOCK_SERVER_PORT')
  end
end

# General helpers
def build_deepl_api
  DeepL::API.new(DeepL::Configuration.new)
end

# Test helpers

def replace_env_preserving_deepl_vars
  env_auth_key = ENV.fetch('DEEPL_AUTH_KEY', false)
  env_server_url = ENV.fetch('DEEPL_SERVER_URL', false)
  env_mock_server_port = ENV.fetch('DEEPL_MOCK_SERVER_PORT', false)
  tmp_env = ENV.to_hash
  ENV.clear
  ENV['DEEPL_AUTH_KEY'] = (env_auth_key || 'VALID')
  ENV['DEEPL_SERVER_URL'] = (env_server_url || '')
  ENV['DEEPL_MOCK_SERVER_PORT'] = (env_mock_server_port || '')
  tmp_env
end

def replace_env_preserving_deepl_vars_except_mock_server
  env_auth_key = ENV.fetch('DEEPL_AUTH_KEY', false)
  tmp_env = ENV.to_hash
  ENV.clear
  ENV['DEEPL_AUTH_KEY'] = (env_auth_key || 'VALID')
  tmp_env
end
