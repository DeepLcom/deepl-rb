# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Entries do
  subject(:entries_obj) { described_class.new(api, id) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:id) { '9ab5dac2-b7b2-4b4a-808a-e8e305df5ecb' }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(entries_obj).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'when performing a valid request' do
      it 'returns a list of entries in TSV format' do
        entries = entries_obj.request
        expect(entries).to be_a(Array)
        expect(entries).to all(be_a(Array))
        expect(entries.size).to eq(2)
      end
    end

    context 'when requesting entries with a valid but non existing glossary id' do
      subject(:entries_obj) { described_class.new(api, id) }

      let(:id) { '00000000-0000-0000-0000-000000000000' }

      it 'raises a not found error' do
        expect { entries_obj.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'when requesting entries with an invalid glossary id' do
      subject(:entries_obj) { described_class.new(api, id) }

      let(:id) { 'invalid-uuid' }

      it 'raises a bad request error' do
        expect { entries_obj.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
