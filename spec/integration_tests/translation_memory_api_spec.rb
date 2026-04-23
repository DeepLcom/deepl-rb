# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::TranslationMemoryApi do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  describe '#translate_with_translation_memory' do
    it 'when performing a request with translation_memory_id' do
      skip 'Only runs on mock server' if real_server?

      source_lang = 'DE'
      target_lang = 'EN'
      text = 'Protonenstrahl'
      translation_memory_id = 'a74d88fb-ed2a-4943-a664-a4512398b994'

      result = DeepL.translate(text, source_lang, target_lang,
                               { translation_memory: translation_memory_id })
      expect(result).to be_a(DeepL::Resources::Text)
    end

    it 'when performing a request with translation_memory resource object' do
      skip 'Only runs on mock server' if real_server?

      source_lang = 'DE'
      target_lang = 'EN'
      text = 'Protonenstrahl'
      translation_memory = build_test_translation_memory

      result = DeepL.translate(text, source_lang, target_lang,
                               { translation_memory: translation_memory })
      expect(result).to be_a(DeepL::Resources::Text)
    end
  end

  describe '#list_translation_memories' do
    it 'when requesting a list of all translation memories' do
      skip 'Only runs on mock server' if real_server?

      translation_memories = DeepL.translation_memories.list
      expect(translation_memories).to be_an(Array)
      expect(translation_memories).not_to be_empty
      expect(translation_memories.first).to be_a(DeepL::Resources::TranslationMemory)
      expect(translation_memories.first.translation_memory_id).not_to be_nil
      expect(translation_memories.first.name).not_to be_nil
    end
  end

  def build_test_translation_memory
    tm_data = {
      'translation_memory_id' => 'a74d88fb-ed2a-4943-a664-a4512398b994',
      'name' => 'Default Translation Memory',
      'source_language' => 'DE',
      'target_languages' => %w[EN ES FR],
      'segment_count' => 3542
    }
    DeepL::Resources::TranslationMemory.new(tm_data, nil, nil)
  end
end
