# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Create do
  subject(:create) do
    described_class.new(api, name, source_lang, target_lang, entries, options)
  end

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:name) { 'Mi Glosario' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  let(:entries) do
    [
      %w[Hello Hola],
      %w[World Mundo]
    ]
  end
  let(:entries_format) { 'tsv' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(create).to be_a(described_class)
      end

      it 'sets the default value for the entries format if not specified' do
        request = described_class.new(api, name, source_lang, target_lang,
                                      entries, options)
        expect(request.entries_format).to eq('tsv')
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'when performing a valid request with two glossary entries' do
      it 'returns a glossaries object' do
        glossary = create.request
        expect(glossary).to be_a(DeepL::Resources::Glossary)
        expect(glossary.id).to be_a(String)
        expect(glossary.name).to eq('Mi Glosario')
        expect(glossary.ready).to be(true).or be(false)
        expect(glossary.source_lang).to eq('en')
        expect(glossary.target_lang).to eq('es')
        expect { Time.iso8601(glossary.creation_time) }.not_to raise_error
        expect(glossary.entry_count).to eq(2)
      end
    end
  end
end
