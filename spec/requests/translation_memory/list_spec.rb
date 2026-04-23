# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::TranslationMemory::List do
  subject(:translation_memory_list) { described_class.new(api, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(translation_memory_list).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('translation_memories') { example.call }
    end

    context 'when requesting a list of all translation memories' do
      it 'returns an array of translation memories' do
        translation_memories = translation_memory_list.request
        expect(translation_memories).to be_an(Array)
        expect(translation_memories).not_to be_empty
        expect(translation_memories.first).to be_a(DeepL::Resources::TranslationMemory)
        expect(translation_memories.first.translation_memory_id).to be_a(String)
        expect(translation_memories.first.name).to be_a(String)
        expect(translation_memories.first.source_language).to be_a(String)
        expect(translation_memories.first.target_languages).to be_an(Array)
        expect(translation_memories.first.segment_count).to be_an(Integer)
      end
    end

    context 'when performing a bad request' do
      context 'when using an invalid token' do
        let(:api) do
          api = build_deepl_api
          api.configuration.auth_key = 'invalid'
          api
        end

        it 'raises an authorization failed error' do
          expect { translation_memory_list.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
        end
      end
    end
  end
end
