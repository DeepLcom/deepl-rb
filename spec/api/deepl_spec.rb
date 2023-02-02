# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL do
  subject(:deepl) { described_class.dup }

  describe '#configure' do
    context 'when providing no block' do
      let(:configuration) { DeepL::Configuration.new }

      before { deepl.configure }

      it 'uses default configuration' do
        expect(deepl.configuration).to eq(configuration)
      end
    end

    context 'when providing a valid configuration' do
      let(:configuration) do
        DeepL::Configuration.new(auth_key: 'VALID', host: 'http://www.example.org', version: 'v1')
      end

      before do
        deepl.configure do |config|
          config.auth_key = configuration.auth_key
          config.host = configuration.host
          config.version = configuration.version
        end
      end

      it 'uses the provided configuration' do
        expect(deepl.configuration).to eq(configuration)
      end
    end

    context 'when providing an invalid configuration' do
      it 'raises an error' do
        expect { deepl.configure { |c| c.auth_key = '' } }
          .to raise_error(DeepL::Exceptions::Error)
      end
    end
  end

  describe '#translate' do
    let(:input) { 'Sample' }
    let(:source_lang) { 'EN' }
    let(:target_lang) { 'ES' }
    let(:options) { { param: 'fake' } }

    around do |example|
      deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_translate') { example.call }
    end

    context 'when translating a text' do
      it 'creates and call a request object' do
        expect(DeepL::Requests::Translate).to receive(:new)
          .with(deepl.api, input, source_lang, target_lang, options).and_call_original

        text = deepl.translate(input, source_lang, target_lang, options)
        expect(text).to be_a(DeepL::Resources::Text)
      end
    end

    context 'when translating a text using a glossary' do
      before do
        @glossary = deepl.glossaries.create('fixture', 'EN', 'ES', [%w[car auto]])
      end

      let(:input) { 'I wish we had a car.' }
      # rubocop:disable RSpec/InstanceVariable
      let(:options) { { glossary_id: @glossary.id } }

      after do
        deepl.glossaries.destroy(@glossary.id)
      end
      # rubocop:enable RSpec/InstanceVariable

      it 'creates and call a request object' do
        expect(DeepL::Requests::Translate).to receive(:new)
          .with(deepl.api, input, source_lang, target_lang, options).and_call_original
        text = deepl.translate(input, source_lang, target_lang, options)
        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Ojalá tuviéramos un auto.')
      end
    end
  end

  describe '#usage' do
    let(:options) { {} }

    around do |example|
      deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_usage') { example.call }
    end

    context 'when checking usage' do
      it 'creates and call a request object' do
        expect(DeepL::Requests::Usage).to receive(:new)
          .with(deepl.api, options).and_call_original

        usage = deepl.usage(options)
        expect(usage).to be_a(DeepL::Resources::Usage)
      end
    end
  end

  describe '#languages' do
    let(:options) { { type: :target } }

    around do |example|
      deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_languages') { example.call }
    end

    context 'when checking languages' do
      it 'creates and call a request object' do
        expect(DeepL::Requests::Languages).to receive(:new)
          .with(deepl.api, options).and_call_original

        languages = deepl.languages(options)
        expect(languages).to be_an(Array)
        expect(languages).to(be_all { |l| l.is_a?(DeepL::Resources::Language) })
      end
    end
  end

  describe '#glossaries' do
    describe '#glossaries.create' do
      let(:name) { 'Mi Glosario' }
      let(:source_lang) { 'EN' }
      let(:target_lang) { 'ES' }
      let(:entries) do
        [
          %w[Hello Hola],
          %w[World Mundo]
        ]
      end
      let(:options) { { param: 'fake', entries_format: 'tsv' } }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when creating a glossary' do
        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::Create).to receive(:new)
            .with(deepl.api, name, source_lang, target_lang, entries, options).and_call_original

          glossary = deepl.glossaries.create(name, source_lang, target_lang, entries, options)
          expect(glossary).to be_a(DeepL::Resources::Glossary)
        end
      end
    end

    describe '#glossaries.find' do
      let(:id) { 'd9ad833f-c818-430c-a3c9-47071384fa3e' }
      let(:options) { {} }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when fetching a glossary' do
        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::Find).to receive(:new)
            .with(deepl.api, id, options).and_call_original

          glossary = deepl.glossaries.find(id, options)
          expect(glossary).to be_a(DeepL::Resources::Glossary)
        end
      end

      context 'when fetching a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'raises an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Find).to receive(:new)
            .with(deepl.api, id, options).and_call_original
          expect { deepl.glossaries.find(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.list' do
      let(:options) { {} }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when fetching glossaries' do
        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::List).to receive(:new)
            .with(deepl.api, options).and_call_original

          glossaries = deepl.glossaries.list(options)
          expect(glossaries).to all(be_a(DeepL::Resources::Glossary))
        end
      end
    end

    describe '#glossaries.destroy' do
      let(:id) { 'd9ad833f-c818-430c-a3c9-47071384fa3e' }
      let(:options) { {} }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when destroy a glossary' do
        let(:new_glossary) do
          deepl.glossaries.create('fixture', 'EN', 'ES', [%w[Hello Hola]])
        end

        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::Destroy).to receive(:new)
            .with(deepl.api, new_glossary.id, options).and_call_original

          glossary_id = deepl.glossaries.destroy(new_glossary.id, options)
          expect(glossary_id).to eq(new_glossary.id)
        end
      end

      context 'when destroying a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'raises an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Destroy).to receive(:new)
            .with(deepl.api, id, options).and_call_original
          expect { deepl.glossaries.destroy(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.entries' do
      let(:id) { '012a5576-b551-4d4c-b917-ce01bc8debb6' }
      let(:options) { {} }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when listing glossary entries' do
        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::Entries).to receive(:new)
            .with(deepl.api, id, options).and_call_original

          entries = deepl.glossaries.entries(id, options)
          expect(entries).to all(be_a(Array))
          entries.each do |entry|
            expect(entry.size).to eq(2)
            expect(entry.first).to be_a(String)
            expect(entry.last).to be_a(String)
          end
        end
      end

      context 'when listing entries of a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'raises an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Entries).to receive(:new)
            .with(deepl.api, id, options).and_call_original
          expect { deepl.glossaries.entries(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.language_pairs' do
      let(:options) { {} }

      around do |example|
        deepl.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'when fetching language pairs supported by glossaries' do
        it 'creates and call a request object' do
          expect(DeepL::Requests::Glossary::LanguagePairs).to receive(:new)
            .with(deepl.api, options).and_call_original

          language_pairs = deepl.glossaries.language_pairs(options)
          expect(language_pairs).to all(be_a(DeepL::Resources::LanguagePair))
        end
      end
    end
  end
end
