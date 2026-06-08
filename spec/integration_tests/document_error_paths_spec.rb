# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::DocumentApi, :mock_server_only do # rubocop:disable RSpec/SpecFilePathFormat
  include_context 'with a live mock server'

  let(:source_lang) { 'EN' }
  let(:target_lang) { 'DE' }
  let(:document_path) { example_document_path(source_lang) }

  describe 'authorization failures' do
    let(:unauthorized_documents) { described_class.new(unauthorized_api) }

    it 'raises AuthorizationFailed when uploading with an invalid auth key' do
      expect { unauthorized_documents.upload(document_path, source_lang, target_lang) }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end

  describe 'translation failures' do
    it 'reports an error status when the server fails the document' do
      handle = DeepL.document.upload(document_path, source_lang, target_lang,
                                     File.basename(document_path), {}, fail_docs_header(1))
      status = handle.wait_until_document_translation_finished

      expect(status.status).to eq('error')
    end
  end
end
