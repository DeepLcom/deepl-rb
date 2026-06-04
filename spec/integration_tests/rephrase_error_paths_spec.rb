# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'securerandom'
require 'spec_helper'

describe 'DeepL.rephrase error paths', :mock_server_only do # rubocop:disable RSpec/DescribeClass
  include IntegrationTestUtils

  include_context 'with a live mock server'

  let(:sample_text) { 'As Gregor Samsa awoke one morning he found himself transformed.' }

  def rephrase_with_fresh_user(headers)
    fresh_auth_key = "rephrase-err-#{SecureRandom.uuid}"
    config = DeepL::Configuration.new(auth_key: fresh_auth_key)
    config.max_network_retries = 0
    api = DeepL::API.new(config)
    DeepL::Requests::Rephrase.new(api, sample_text, 'en', nil, nil, {}, headers).request
  end

  describe 'authorization failures' do
    it 'raises AuthorizationFailed when called with an invalid auth_key' do
      request = DeepL::Requests::Rephrase.new(unauthorized_api, sample_text, 'en')

      expect { request.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end

  describe 'bad request errors' do
    it 'raises BadRequest for an unsupported target_lang code' do
      expect do
        DeepL.rephrase(sample_text, 'zzz')
      end.to raise_error(DeepL::Exceptions::BadRequest)
    end
  end

  describe 'rate limiting' do
    it 'raises LimitExceeded when the server responds with 429' do
      expect do
        rephrase_with_fresh_user(respond_with_429_header(1))
      end.to raise_error(DeepL::Exceptions::LimitExceeded)
    end
  end
end
