# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::Create do
  subject(:create) { described_class.new(api, name, language, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:name) { 'Test Style Rule' }
  let(:language) { 'en' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(create).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      it 'returns a style rule object' do
        style_rule = create.request
        expect(style_rule).to be_a(DeepL::Resources::StyleRule)
        expect(style_rule.style_id).to be_a(String)
        expect(style_rule.name).to eq('Test Style Rule')
        expect(style_rule.language).to eq('en')
      end
    end
  end
end
