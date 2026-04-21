# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::CreateCustomInstruction do
  subject(:create_instruction) { described_class.new(api, style_id, label, prompt, nil, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:label) { 'Test Instruction' }
  let(:prompt) { 'Always use formal language' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(create_instruction).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:create_instruction) do
        described_class.new(api, new_rule.style_id, label, prompt)
      end

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Instruction Test', 'en').request
      end

      it 'returns a custom instruction object' do
        instruction = create_instruction.request
        expect(instruction).to be_a(DeepL::Resources::CustomInstruction)
        expect(instruction.id).to be_a(String)
        expect(instruction.label).to eq('Test Instruction')
        expect(instruction.prompt).to eq('Always use formal language')
      end
    end
  end
end
