# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::StyleRule::DestroyCustomInstruction do
  subject(:destroy_instruction) { described_class.new(api, style_id, instruction_id) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:style_id) { 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4' }
  let(:instruction_id) { 'test-instruction-id' }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(destroy_instruction).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('style_rules_crud') { example.call }
    end

    context 'when performing a valid request' do
      subject(:destroy_instruction) do
        described_class.new(api, new_rule.style_id, new_instruction.id)
      end

      let(:new_rule) do
        DeepL::Requests::StyleRule::Create.new(api, 'Destroy Instruction Test', 'en').request
      end
      let(:new_instruction) do
        DeepL::Requests::StyleRule::CreateCustomInstruction.new(
          api, new_rule.style_id, 'To Delete', 'Delete me'
        ).request
      end

      it 'returns the deleted instruction id' do
        response = destroy_instruction.request
        expect(response).to eq(new_instruction.id)
      end
    end
  end
end
