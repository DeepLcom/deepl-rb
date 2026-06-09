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
end
