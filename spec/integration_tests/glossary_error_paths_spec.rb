# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::GlossaryApi, :mock_server_only do # rubocop:disable RSpec/SpecFilePathFormat
  include_context 'with a live mock server'

  let(:nonexistent_glossary_id) { '00000000-0000-0000-0000-000000000000' }

  let(:valid_glossary_args) do
    {
      name: 'Error Path Test Glossary',
      source_lang: 'en',
      target_lang: 'de',
      entries: [%w[Hello Hallo]]
    }
  end

  describe 'AuthorizationFailed (401/403)' do
    let(:unauthorized_glossaries) { described_class.new(unauthorized_api) }

    it 'is raised by #list when the auth key is invalid' do
      expect { unauthorized_glossaries.list }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end

    it 'is raised by #language_pairs when the auth key is invalid' do
      expect { unauthorized_glossaries.language_pairs }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end

    it 'is raised by #create when the auth key is invalid' do
      expect do
        unauthorized_glossaries.create(
          valid_glossary_args[:name],
          valid_glossary_args[:source_lang],
          valid_glossary_args[:target_lang],
          valid_glossary_args[:entries]
        )
      end.to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end

    it 'is raised by #find when the auth key is invalid' do
      expect { unauthorized_glossaries.find(nonexistent_glossary_id) }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end

    it 'is raised by #destroy when the auth key is invalid' do
      expect { unauthorized_glossaries.destroy(nonexistent_glossary_id) }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end

  describe 'NotFound (404)' do
    it 'is raised by #find for a well-formed but unknown glossary id' do
      expect { DeepL.glossaries.find(nonexistent_glossary_id) }
        .to raise_error(DeepL::Exceptions::NotFound)
    end

    it 'is raised by #destroy for a well-formed but unknown glossary id' do
      expect { DeepL.glossaries.destroy(nonexistent_glossary_id) }
        .to raise_error(DeepL::Exceptions::NotFound)
    end
  end

  describe 'BadRequest (400) from #create' do
    it 'is raised for an invalid source language code' do
      expect do
        DeepL.glossaries.create(
          valid_glossary_args[:name],
          'zz',
          valid_glossary_args[:target_lang],
          valid_glossary_args[:entries]
        )
      end.to raise_error(DeepL::Exceptions::BadRequest)
    end
  end
end
