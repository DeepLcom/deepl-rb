# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::UpdateConfiguredRules do
  subject(:update_configured_rules) do
    described_class.new(api, style_id, configured_rules, options)
  end

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:configured_rules) { { 'dates_and_times' => { 'calendar_era' => 'use_bc_and_ad' } } }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(update_configured_rules).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:update_configured_rules) do
        described_class.new(api, new_rule.style_id, configured_rules)
      end

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Configured Rules Test', 'en').request
      end

      it 'returns a style rule object' do
        style_rule = update_configured_rules.request
        expect(style_rule).to be_a(DeepL::Resources::StyleRule)
      end
    end
  end
end
