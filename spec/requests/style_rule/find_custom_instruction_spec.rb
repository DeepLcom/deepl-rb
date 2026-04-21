# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::FindCustomInstruction do
  subject(:find_instruction) { described_class.new(api, style_id, instruction_id, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:instruction_id) { 'test-instruction-id' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(find_instruction).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:find_instruction) do
        described_class.new(api, new_rule.style_id, new_instruction.id)
      end

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Find Instruction Test', 'en').request
      end
      let(:new_instruction) do
        DeepL::Requests::StyleRule::CreateCustomInstruction.new(
          api, new_rule.style_id, 'Test', 'Test prompt'
        ).request
      end

      it 'returns a custom instruction object' do
        instruction = find_instruction.request
        expect(instruction).to be_a(DeepL::Resources::CustomInstruction)
        expect(instruction.id).to eq(new_instruction.id)
      end
    end
  end
end
