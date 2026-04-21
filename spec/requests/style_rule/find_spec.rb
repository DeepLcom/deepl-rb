# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::Find do
  subject(:style_rule_find) { described_class.new(api, style_id, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(style_rule_find).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:style_rule_find) do
        new_rule = DeepL::Requests::StyleRule::Create.new(api, 'Find Test', 'en').request
        described_class.new(api, new_rule.style_id, options)
      end

      it 'returns a style rule object' do
        style_rule = style_rule_find.request
        expect(style_rule).to be_a(DeepL::Resources::StyleRule)
        expect(style_rule.style_id).to be_a(String)
        expect(style_rule.name).to be_a(String)
      end
    end

    context 'when requesting a non existing style rule with an invalid id' do
      let(:style_id) { 'invalid-uuid' }

      it 'raises an error' do
        expect { style_rule_find.request }.to raise_error(DeepL::Exceptions::Error)
      end
    end
  end
end
