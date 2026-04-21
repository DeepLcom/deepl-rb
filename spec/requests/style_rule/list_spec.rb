# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::List do
  subject(:style_rule_list) { described_class.new(api, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(style_rule_list).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules') { example.call }
    end

    context 'when requesting a list of all style rules' do
      it 'returns an array of style rules' do
        style_rules = style_rule_list.request
        expect(style_rules).to be_an(Array)
        expect(style_rules).not_to be_empty
        expect(style_rules.first).to be_a(DeepL::Resources::StyleRule)
        expect(style_rules.first.style_id).to be_a(String)
        expect(style_rules.first.name).to be_a(String)
      end
    end

    context 'when performing a bad request' do
      context 'when using an invalid token' do
        let(:api) do
          api = build_deepl_api
          api.configuration.auth_key = 'invalid'
          api
        end

        it 'raises an authorization failed error' do
          expect { style_rule_list.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
        end
      end
    end
  end
end
