# Copyright 2024 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

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

    it 'Translates a document from a filepath without a filename' do
      File.unlink(output_document_path)
      source_lang = default_lang_args[:source_lang]
      target_lang = default_lang_args[:target_lang]
      example_doc_path = example_document_path(source_lang)
      DeepL.document.translate_document(example_doc_path, output_document_path,
                                        source_lang, target_lang)
      output_file_contents = File.read(output_document_path)

      expect(example_document_translation(target_lang)).to eq(output_file_contents)
    end

    it 'Translates a document using the lower-level methods and returns the correct status' do # rubocop:disable RSpec/ExampleLength
      File.unlink(output_document_path)
      source_lang = default_lang_args[:source_lang]
      target_lang = default_lang_args[:target_lang]
      example_doc_path = example_document_path(source_lang)

      handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                     File.basename(example_doc_path), {})
      doc_status = handle.wait_until_document_translation_finished
      DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
      output_file_contents = File.read(output_document_path)

      expect(example_document_translation(target_lang)).to eq(output_file_contents)
      expect(doc_status.billed_characters).to eq(example_document_translation(source_lang).length)
      expect(doc_status.status).to eq('done')
    end

    it 'Translates a document after retrying the upload once' do # rubocop:disable RSpec/ExampleLength
      skip 'Only runs on mock server' if real_server?
      File.unlink(output_document_path)
      source_lang = default_lang_args[:source_lang]
      target_lang = default_lang_args[:target_lang]
      example_doc_path = example_document_path(source_lang)
      doc_status = nil
      DeepL.with_session(DeepL::HTTPClientOptions.new({}, nil, enable_ssl_verification: false,
                                                               read_timeout: 1.0)) do |_session|
        handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                       File.basename(example_doc_path), {}, no_response_header(1))
        doc_status = handle.wait_until_document_translation_finished
        DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
      end
      output_file_contents = File.read(output_document_path)

      expect(output_file_contents).to eq(example_document_translation(target_lang))
      expect(doc_status.billed_characters).to eq(example_document_translation(source_lang).length)
      expect(doc_status.status).to eq('done')
    end
  end

  it 'Translates a document after waiting' do # rubocop:disable RSpec/ExampleLength
    skip 'Only runs on mock server' if real_server?
    File.unlink(output_document_path)
    source_lang = default_lang_args[:source_lang]
    target_lang = default_lang_args[:target_lang]
    example_doc_path = example_document_path(source_lang)
    doc_status = nil
    DeepL.with_session(DeepL::HTTPClientOptions.new({}, nil,
                                                    enable_ssl_verification: false)) do |_session|
      handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                     File.basename(example_doc_path), {},
                                     doc_translation_queue_time_header(2000).merge(doc_translation_translation_time_header(2000))) # rubocop:disable Layout/LineLength
      doc_status = handle.wait_until_document_translation_finished
      DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
    end
    output_file_contents = File.read(output_document_path)

    expect(output_file_contents).to eq(example_document_translation(target_lang))
    expect(doc_status.billed_characters).to eq(example_document_translation(source_lang).length)
    expect(doc_status.status).to eq('done')
  end

  it 'Translates a large document' do # rubocop:disable RSpec/ExampleLength
    skip 'Only runs on mock server' if real_server?
    File.unlink(output_document_path)
    source_lang = default_lang_args[:source_lang]
    target_lang = default_lang_args[:target_lang]
    example_doc_path = example_large_document_path(source_lang)
    doc_status = nil
    DeepL.with_session(DeepL::HTTPClientOptions.new({}, nil,
                                                    enable_ssl_verification: false)) do |_session|
      handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                     File.basename(example_doc_path), {})
      doc_status = handle.wait_until_document_translation_finished
      DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
    end
    output_file_contents = File.read(output_document_path)

    expect(output_file_contents).to eq(example_large_document_translation(target_lang))
    expect(doc_status.billed_characters).to eq(
      example_large_document_translation(source_lang).length
    )
    expect(doc_status.status).to eq('done')
  end

  it 'Translates a document with formality set' do # rubocop:disable RSpec/ExampleLength
    skip 'Only runs on mock server' if real_server?
    File.unlink(output_document_path)
    source_lang = default_lang_args[:source_lang]
    target_lang = default_lang_args[:target_lang]
    example_doc_path = example_large_document_path(source_lang)
    doc_status = nil
    DeepL.with_session(DeepL::HTTPClientOptions.new({}, nil,
                                                    enable_ssl_verification: false)) do |_session|
      handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                     File.basename(example_doc_path),
                                     { 'formality' => 'prefer_more' })
      doc_status = handle.wait_until_document_translation_finished
      DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
    end
    output_file_contents = File.read(output_document_path)

    expect(output_file_contents).to eq(example_large_document_translation(target_lang))
    expect(doc_status.billed_characters).to eq(
      example_large_document_translation(source_lang).length
    )
    expect(doc_status.status).to eq('done')
  end

  it 'Translates a document with extra_body_parameters' do # rubocop:disable RSpec/ExampleLength
    File.unlink(output_document_path)
    source_lang = default_lang_args[:source_lang]
    target_lang = default_lang_args[:target_lang]
    example_doc_path = example_document_path(source_lang)

    handle = DeepL.document.upload(example_doc_path, source_lang, target_lang,
                                   File.basename(example_doc_path),
                                   {
                                     extra_body_parameters: {
                                       target_lang: 'FR',
                                       debug: '1'
                                     }
                                   })
    doc_status = handle.wait_until_document_translation_finished
    DeepL.document.download(handle, output_document_path) if doc_status.status != 'error'
    output_file_contents = File.read(output_document_path)

    expect(example_document_translation('FR')).to eq(output_file_contents)
    expect(doc_status.status).to eq('done')
  end
end
