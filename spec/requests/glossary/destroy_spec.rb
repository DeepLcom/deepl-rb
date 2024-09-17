# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Destroy do
  subject(:destroy) { described_class.new(api, id) }

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
        expect(destroy).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'when performing a valid request' do
      subject(:destroy) { described_class.new(api, new_glossary.id) }

      let(:new_glossary) do
        DeepL::Requests::Glossary::Create.new(api, 'fixture', 'EN', 'ES', [%w[Hello Hola]]).request
      end

      it 'returns an empty object' do
        response = destroy.request
        expect(response).to eq(new_glossary.id)
      end
    end

    context 'when deleting a non existing glossary with a valid id' do
      subject(:destroy) { described_class.new(api, id) }

      let(:id) { '00000000-0000-0000-0000-000000000000' }

      it 'raises a not found error' do
        expect { destroy.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'when deleting a non existing glossary with an invalid id' do
      subject(:destroy) { described_class.new(api, id) }

      let(:id) { 'invalid-uuid' }

      it 'raises a bad request error' do
        expect { destroy.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
