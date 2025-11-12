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
