# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::CustomInstruction do
  subject(:custom_instruction) do
    described_class.new({
                          'id' => 'ci-1',
                          'label' => 'Formal',
                          'prompt' => 'Always use formal language',
                          'source_language' => 'en'
                        })
  end

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(custom_instruction).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(custom_instruction.id).to eq('ci-1')
        expect(custom_instruction.label).to eq('Formal')
        expect(custom_instruction.prompt).to eq('Always use formal language')
        expect(custom_instruction.source_language).to eq('en')
      end
    end
  end
end
