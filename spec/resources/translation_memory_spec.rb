# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::TranslationMemory do
  subject(:translation_memory) do
    described_class.new({
                          'translation_memory_id' => 'a74d88fb-ed2a-4943-a664-a4512398b994',
                          'name' => 'Legal',
                          'source_language' => 'en',
                          'target_languages' => %w[es de],
                          'segment_count' => 3542
                        }, nil, nil)
  end

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(translation_memory).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(translation_memory.translation_memory_id)
          .to eq('a74d88fb-ed2a-4943-a664-a4512398b994')
        expect(translation_memory.name).to eq('Legal')
        expect(translation_memory.source_language).to eq('en')
        expect(translation_memory.target_languages).to eq(%w[es de])
        expect(translation_memory.segment_count).to eq(3542)
      end
    end
  end
end
