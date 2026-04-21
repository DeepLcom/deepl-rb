# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::StyleRuleApi do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  describe '#translate_with_style_rules' do
    it 'when performing a request with style_id' do
      skip 'Only runs on mock server' if real_server?

      source_lang = 'DE'
      target_lang = 'EN-US'
      text = 'Hallo, Welt!'
      style_id = 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4'

      result = DeepL.translate(text, source_lang, target_lang, { style_rule: style_id })
      expect(result).to be_a(DeepL::Resources::Text)
    end

    it 'when performing a request with style_rule object' do
      skip 'Only runs on mock server' if real_server?

      source_lang = 'DE'
      target_lang = 'EN-US'
      text = 'Hallo, Welt!'
      style_rule = build_test_style_rule

      result = DeepL.translate(text, source_lang, target_lang, { style_rule: style_rule })
      expect(result).to be_a(DeepL::Resources::Text)
    end
  end

  describe '#list_style_rules' do
    it 'when requesting a list of all style rules' do
      skip 'Only runs on mock server' if real_server?
      style_rules = DeepL.style_rules.list(page: 0, page_size: 10, detailed: true)
      expect(style_rules).to be_an(Array)
      expect(style_rules.length).to eq(1)
      expect(style_rules[0].style_id).to eq('dca2e053-8ae5-45e6-a0d2-881156e7f4e4')
      expect(style_rules[0].name).to eq('Default Style Rule')
      expect(style_rules[0].configured_rules).to be_a(DeepL::Resources::ConfiguredRules)
      expect(style_rules[0].custom_instructions).to be_an(Array)
    end

    it 'when requesting a list of all style rules without detailed' do
      skip 'Only runs on mock server' if real_server?
      style_rules = DeepL.style_rules.list
      expect(style_rules).to be_an(Array)
      expect(style_rules.length).to eq(1)
      expect(style_rules[0].style_id).to eq('dca2e053-8ae5-45e6-a0d2-881156e7f4e4')
      expect(style_rules[0].configured_rules).to be_nil
      expect(style_rules[0].custom_instructions).to be_nil
    end
  end

  describe 'style rule management operations' do
    it 'when performing all management operations on style rules' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      skip 'Only runs on mock server' if real_server?

      # Create a style rule
      style_rule = DeepL.style_rules.create('Test Style Rule', 'en')
      expect(style_rule).to be_a(DeepL::Resources::StyleRule)
      expect(style_rule.style_id).not_to be_nil
      style_id = style_rule.style_id

      # Find the style rule
      found_rule = DeepL.style_rules.find(style_id)
      expect(found_rule).to be_a(DeepL::Resources::StyleRule)
      expect(found_rule.style_id).to eq(style_id)

      # Update the style rule name
      updated_rule = DeepL.style_rules.update_name(style_id, 'Updated Style Rule')
      expect(updated_rule).to be_a(DeepL::Resources::StyleRule)

      # Update configured rules
      configured_rules = {
        'dates_and_times' => { 'calendar_era' => 'use_bc_and_ad' }
      }
      updated_rule = DeepL.style_rules.update_configured_rules(style_id, configured_rules)
      expect(updated_rule).to be_a(DeepL::Resources::StyleRule)

      # Create a custom instruction
      custom_instruction = DeepL.style_rules.create_custom_instruction(
        style_id, 'Test Instruction', 'Always use formal language'
      )
      expect(custom_instruction).to be_a(DeepL::Resources::CustomInstruction)
      expect(custom_instruction.id).not_to be_nil
      instruction_id = custom_instruction.id

      # Find a custom instruction
      fetched_instruction = DeepL.style_rules.find_custom_instruction(style_id, instruction_id)
      expect(fetched_instruction).to be_a(DeepL::Resources::CustomInstruction)
      expect(fetched_instruction.id).to eq(instruction_id)

      # Update a custom instruction
      updated_instruction = DeepL.style_rules.update_custom_instruction(
        style_id, instruction_id, 'Updated Instruction', 'Use casual language'
      )
      expect(updated_instruction).to be_a(DeepL::Resources::CustomInstruction)

      # Destroy the custom instruction
      deleted_instruction_id = DeepL.style_rules.destroy_custom_instruction(style_id,
                                                                            instruction_id)
      expect(deleted_instruction_id).to eq(instruction_id)

      # Destroy the style rule
      deleted_style_id = DeepL.style_rules.destroy(style_id)
      expect(deleted_style_id).to eq(style_id)
    end
  end

  def build_test_style_rule
    style_rule_data = {
      'style_id' => 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4',
      'name' => 'Default Style Rule',
      'creation_time' => '2025-01-01T00:00:00Z',
      'updated_time' => '2025-01-01T00:00:00Z',
      'language' => 'en',
      'version' => 1
    }
    DeepL::Resources::StyleRule.new(style_rule_data, nil, nil)
  end
end
