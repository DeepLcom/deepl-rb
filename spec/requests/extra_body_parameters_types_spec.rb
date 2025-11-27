# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe 'DeepL::Requests::Base extra_body_parameters type preservation' do
  let(:api) { build_deepl_api }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  describe 'apply_extra_body_parameters_to_json' do
    it 'preserves boolean true' do
      request = DeepL::Requests::Translate.new(
        api, 'test', 'EN', 'ES',
        extra_body_parameters: { enable_beta_languages: true }
      )

      payload = {}
      request.send(:apply_extra_body_parameters_to_json, payload)

      expect(payload[:enable_beta_languages]).to be(true)
      expect(payload[:enable_beta_languages]).to be_a(TrueClass)
    end

    it 'preserves boolean false' do
      request = DeepL::Requests::Translate.new(
        api, 'test', 'EN', 'ES',
        extra_body_parameters: { some_flag: false }
      )

      payload = {}
      request.send(:apply_extra_body_parameters_to_json, payload)

      expect(payload[:some_flag]).to be(false)
      expect(payload[:some_flag]).to be_a(FalseClass)
    end

    it 'preserves integers' do
      request = DeepL::Requests::Translate.new(
        api, 'test', 'EN', 'ES',
        extra_body_parameters: { some_number: 42 }
      )

      payload = {}
      request.send(:apply_extra_body_parameters_to_json, payload)

      expect(payload[:some_number]).to eq(42)
      expect(payload[:some_number]).to be_a(Integer)
    end

    it 'preserves strings' do
      request = DeepL::Requests::Translate.new(
        api, 'test', 'EN', 'ES',
        extra_body_parameters: { some_string: 'hello' }
      )

      payload = {}
      request.send(:apply_extra_body_parameters_to_json, payload)

      expect(payload[:some_string]).to eq('hello')
      expect(payload[:some_string]).to be_a(String)
    end

    it 'allows overriding standard parameters' do
      request = DeepL::Requests::Translate.new(
        api, 'test', 'EN', 'ES',
        extra_body_parameters: { target_lang: 'FR' }
      )

      payload = { target_lang: 'ES' }
      request.send(:apply_extra_body_parameters_to_json, payload)

      expect(payload[:target_lang]).to eq('FR')
    end
  end
end
