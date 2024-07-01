# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Find do
  subject(:glossary_find) { described_class.new(api, id, options) }

  let(:api) { build_deepl_api }
  let(:id) { '9ab5dac2-b7b2-4b4a-808a-e8e305df5ecb' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(glossary_find).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'when performing a valid request' do
      it 'returns a glossary object' do
        glossary = glossary_find.request
        expect(glossary).to be_a(DeepL::Resources::Glossary)
        expect(glossary.id).to eq('9ab5dac2-b7b2-4b4a-808a-e8e305df5ecb')
        expect(glossary.name).to eq('Mi Glosario')
        expect(glossary.ready).to be(true).or be(false)
        expect(glossary.source_lang).to eq('en')
        expect(glossary.target_lang).to eq('es')
        expect { Time.iso8601(glossary.creation_time) }.not_to raise_error
        expect(glossary.entry_count).to eq(2)
      end
    end

    context 'when requesting a non existing glossary with a valid id' do
      subject(:glossary_find) { described_class.new(api, id, options) }

      let(:id) { 'a0af40e1-d81b-4aab-a95c-7cafbcfd1eb1' }

      it 'raises a not found error' do
        expect { glossary_find.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'when requesting a non existing glossary with an invalid id' do
      subject(:glossary_find) { described_class.new(api, id, options) }

      let(:id) { 'invalid-uuid' }

      it 'raises a bad request error' do
        expect { glossary_find.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
