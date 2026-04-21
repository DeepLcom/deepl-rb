# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::Destroy do
  subject(:destroy) { described_class.new(api, style_id) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(destroy).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:destroy) { described_class.new(api, new_rule.style_id) }

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Destroy Test', 'en').request
      end

      it 'returns the deleted style rule id' do
        response = destroy.request
        expect(response).to eq(new_rule.style_id)
      end
    end

    context 'when deleting a non existing style rule with an invalid id' do
      let(:style_id) { 'invalid-uuid' }

      it 'raises an error' do
        expect { destroy.request }.to raise_error(DeepL::Exceptions::Error)
      end
    end
  end
end
