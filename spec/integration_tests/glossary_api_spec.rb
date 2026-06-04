# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::GlossaryApi, :mock_server_only do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  let(:default_glossary_args) do
    {
      name: 'Integration Test Glossary',
      source_lang: 'en',
      target_lang: 'de',
      entries: [%w[Hello Hallo], %w[World Welt]]
    }
  end

  describe 'happy path lifecycle' do
    it 'creates, lists, and finds a glossary' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      with_managed_glossary(**default_glossary_args) do |glossary|
        expect(glossary).to be_a(DeepL::Resources::Glossary)
        expect(glossary.id).to be_a(String)
        expect(glossary.name).to eq(default_glossary_args[:name])
        expect(glossary.entry_count).to eq(2)

        listed = DeepL.glossaries.list
        expect(listed).to be_an(Array)
        expect(listed.map(&:id)).to include(glossary.id)

        found = DeepL.glossaries.find(glossary.id)
        expect(found).to be_a(DeepL::Resources::Glossary)
        expect(found.id).to eq(glossary.id)
        expect(found.name).to eq(glossary.name)
      end
    end
  end

  describe '#language_pairs' do
    it 'returns a non-empty list of supported source/target combos' do
      pairs = DeepL.glossaries.language_pairs
      expect(pairs).to be_an(Array)
      expect(pairs).not_to be_empty
      expect(pairs.first).to be_a(DeepL::Resources::LanguagePair)
      expect(pairs.first.source_lang).to be_a(String)
      expect(pairs.first.target_lang).to be_a(String)
    end
  end

  describe 'error handling' do
    it 'raises when creating a glossary with an invalid source language code' do
      expect do
        DeepL.glossaries.create(
          'Invalid Lang Glossary',
          'zz',
          'de',
          [%w[Hello Hallo]]
        )
      end.to raise_error(DeepL::Exceptions::RequestError)
    end
  end

  describe 'edge cases' do
    it 'accepts Unicode keys and values in glossary entries' do # rubocop:disable RSpec/ExampleLength
      unicode_entries = [
        ['Schöne Grüße', 'Best regards'],
        ['🚀 rocket', '🚀 fusée'],
        ['日本語', 'Japanese'],
        ['café', 'kafē']
      ]
      args = default_glossary_args.merge(
        name: 'Unicode Glossary',
        entries: unicode_entries
      )

      with_managed_glossary(**args) do |glossary|
        expect(glossary.entry_count).to eq(unicode_entries.length)
      end
    end
  end
end
