# frozen_string_literal: true

require 'spec_helper'
require_relative 'integration_test_utils'

describe DeepL::DocumentApi do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  default_lang_args = { source_lang: 'EN', target_lang: 'DE' }
  include_context 'with temp dir'

  describe '#translate_document' do
    it 'Translates a document from a filepath' do
      File.unlink(output_document_path)
      source_lang = default_lang_args[:source_lang]
      target_lang = default_lang_args[:target_lang]
      example_doc_path = example_document_path(source_lang)
      DeepL.document.translate_document(example_doc_path, output_document_path,
                                        source_lang, target_lang, File.basename(example_doc_path),
                                        {})
      output_file_contents = File.read(output_document_path)

      expect(example_document_translation(target_lang)).to eq(output_file_contents)
    end

    it 'Translates a document using the lower-level methods and returns the correct status' do # rubocop:disable RSpec/ExampleLength
      File.unlink(output_document_path)
      source_lang = default_lang_args[:source_lang]
      target_lang = default_lang_args[:target_lang]
      example_doc_path = example_document_path(source_lang)
      handle = DeepL.document.upload(example_document_path, source_lang, target_lang,
                                     File.basename(example_doc_path), {})
      doc_status = handle.wait_until_document_translation_finished
      DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
      output_file_contents = File.read(output_document_path)

      expect(example_document_translation(target_lang)).to eq(output_file_contents)
      expect(doc_status.billed_characters).to eq(example_document_translation(source_lang).length)
      expect(doc_status.status).to eq('done')
    end
  end
end
