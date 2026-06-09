# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::StyleRule do
  subject(:style_rule) do
    described_class.new({
                          'style_id' => 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4',
                          'name' => 'Default Style Rule',
                          'creation_time' => '2025-01-01T00:00:00Z',
                          'updated_time' => '2025-01-02T00:00:00Z',
                          'language' => 'en',
                          'version' => 1
                        }, nil, nil)
  end

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(style_rule).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(style_rule.style_id).to eq('dca2e053-8ae5-45e6-a0d2-881156e7f4e4')
        expect(style_rule.name).to eq('Default Style Rule')
        expect(style_rule.language).to eq('en')
        expect(style_rule.version).to eq(1)
        expect(style_rule.creation_time).to eq(Time.parse('2025-01-01T00:00:00Z'))
        expect(style_rule.updated_time).to eq(Time.parse('2025-01-02T00:00:00Z'))
        expect(style_rule.configured_rules).to be_nil
        expect(style_rule.custom_instructions).to be_nil
      end
    end

    context 'when building an object with configured rules and custom instructions' do
      subject(:style_rule) do
        described_class.new({
                              'style_id' => 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4',
                              'name' => 'Detailed Style Rule',
                              'language' => 'en',
                              'version' => 1,
                              'configured_rules' => {
                                'dates_and_times' => { 'calendar_era' => 'use_bc_and_ad' }
                              },
                              'custom_instructions' => [
                                { 'id' => 'ci-1', 'label' => 'Test', 'prompt' => 'Be formal' }
                              ]
                            }, nil, nil)
      end

      it 'maps configured_rules into a ConfiguredRules resource' do
        expect(style_rule.configured_rules).to be_a(DeepL::Resources::ConfiguredRules)
        expect(style_rule.configured_rules.dates_and_times)
          .to eq({ 'calendar_era' => 'use_bc_and_ad' })
      end

      it 'maps custom_instructions into an array of CustomInstruction resources' do
        expect(style_rule.custom_instructions).to all(be_a(DeepL::Resources::CustomInstruction))
        expect(style_rule.custom_instructions.first.id).to eq('ci-1')
        expect(style_rule.custom_instructions.first.label).to eq('Test')
        expect(style_rule.custom_instructions.first.prompt).to eq('Be formal')
      end
    end
  end
end
