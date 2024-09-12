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

# Lib config
ENV['DEEPL_AUTH_KEY'] ||= 'TEST-TOKEN'

# General helpers
def build_deepl_api
  DeepL::API.new(DeepL::Configuration.new)
end

uri_ignoring_deepl_api_subdomain = lambda do |request1, request2|
  deepl_api_regexp = %r{https?://api.*\.deepl\.com/}
  uri1 = request1.uri
  uri2 = request2.uri
  uri1_match = uri1.match(deepl_api_regexp)
  uri2_match = uri2.match(deepl_api_regexp)
  if uri1_match && uri2_match
    uri1_without_deepl_domain = uri1.gsub(uri1_match[0], '')
    uri2_without_deepl_domain = uri2.gsub(uri2_match[0], '')
    uri1_without_deepl_domain == uri2_without_deepl_domain
  else
    uri1 == uri2
  end
end

headers_ignoring_user_agent = lambda do |request1, request2|
  user_agent_key = 'User-Agent'
  # Pass by reference, so we need to use a copy of the headers
  headers1 = request1.headers.dup
  headers2 = request2.headers.dup
  headers1_has_user_agent = headers1.key?(user_agent_key)
  headers2_has_user_agent = headers2.key?(user_agent_key)
  return false if headers1_has_user_agent != headers2_has_user_agent

  headers1.delete(user_agent_key)
  headers2.delete(user_agent_key)
  headers1 == headers2
end

# VCR tapes configuration
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('VALID_TOKEN') { ENV.fetch('DEEPL_AUTH_KEY', nil) }
  config.default_cassette_options = {
    # Uncomment this line when adding new tests, run the tests once, then comment it again
    # record: :new_episodes,
    match_requests_on: [:method, uri_ignoring_deepl_api_subdomain, :body,
                        headers_ignoring_user_agent]
  }
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
