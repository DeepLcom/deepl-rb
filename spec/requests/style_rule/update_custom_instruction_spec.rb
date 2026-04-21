# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::UpdateCustomInstruction do
  subject(:update_instruction) do
    described_class.new(api, style_id, instruction_id, label, prompt, nil, {})
  end

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:instruction_id) { 'test-instruction-id' }
  let(:label) { 'Updated Label' }
  let(:prompt) { 'Use casual language' }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(update_instruction).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:update_instruction) do
        described_class.new(api, new_rule.style_id, new_instruction.id, label, prompt)
      end

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Update Instruction Test', 'en').request
      end
      let(:new_instruction) do
        DeepL::Requests::StyleRule::CreateCustomInstruction.new(
          api, new_rule.style_id, 'Original', 'Original prompt'
        ).request
      end

      it 'returns a custom instruction object' do
        instruction = update_instruction.request
        expect(instruction).to be_a(DeepL::Resources::CustomInstruction)
      end
    end
  end
end
