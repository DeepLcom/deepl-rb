# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Translate do
  subject(:translate) { described_class.new(api, text, source_lang, target_lang, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:tags_str) { 'p,strong,span' }
  let(:tags_array) { %w[p strong span] }

  let(:api) { build_deepl_api }
  let(:text) { 'Sample text' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(translate).to be_a(described_class)
      end
    end

    context 'when using `splitting_tags` options' do
      it 'works with a nil values' do
        request = described_class.new(api, nil, nil, nil, splitting_tags: nil)
        expect(request.options[:splitting_tags]).to be_nil
      end

      it 'works with a blank list' do
        request = described_class.new(api, nil, nil, nil, splitting_tags: '')
        expect(request.options[:splitting_tags]).to eq([])
      end

      it 'works with a comma-separated list and converts strings to an array' do
        request = described_class.new(api, nil, nil, nil, splitting_tags: tags_str)
        expect(request.options[:splitting_tags]).to eq(tags_array)
      end

      it 'works with an array of tags and leaves it as is' do
        request = described_class.new(api, nil, nil, nil, splitting_tags: tags_array)
        expect(request.options[:splitting_tags]).to eq(tags_array)
      end
    end

    context 'when using `non_splitting_tags` options' do
      it 'works with a nil values' do
        request = described_class.new(api, nil, nil, nil, non_splitting_tags: nil)
        expect(request.options[:non_splitting_tags]).to be_nil
      end

      it 'works with a blank list' do
        request = described_class.new(api, nil, nil, nil, non_splitting_tags: '')
        expect(request.options[:non_splitting_tags]).to eq([])
      end

      it 'works with a comma-separated list and converts strings to an array' do
        request = described_class.new(api, nil, nil, nil, non_splitting_tags: tags_str)
        expect(request.options[:non_splitting_tags]).to eq(tags_array)
      end

      it 'works with an array and leaves it as it is' do
        request = described_class.new(api, nil, nil, nil, non_splitting_tags: tags_array)
        expect(request.options[:non_splitting_tags]).to eq(tags_array)
      end
    end

    context 'when using `ignore_tags` options' do
      it 'works with a nil values' do
        request = described_class.new(api, nil, nil, nil, ignore_tags: nil)
        expect(request.options[:ignore_tags]).to be_nil
      end

      it 'works with a blank list' do
        request = described_class.new(api, nil, nil, nil, ignore_tags: '')
        expect(request.options[:ignore_tags]).to eq([])
      end

      it 'works with a comma-separated list and converts a string to an array' do
        request = described_class.new(api, nil, nil, nil, ignore_tags: tags_str)
        expect(request.options[:ignore_tags]).to eq(tags_array)
      end

      it 'works with an array and leaves it as it is' do
        request = described_class.new(api, nil, nil, nil, ignore_tags: tags_array)
        expect(request.options[:ignore_tags]).to eq(tags_array)
      end
    end

    context 'when using `split_sentences` options' do
      it 'converts `true` to `1`' do
        request = described_class.new(api, nil, nil, nil, split_sentences: true)
        expect(request.options[:split_sentences]).to eq('1')
      end

      it 'converts `false` to `0`' do
        request = described_class.new(api, nil, nil, nil, split_sentences: false)
        expect(request.options[:split_sentences]).to eq('0')
      end

      it 'leaves `0` as is' do
        request = described_class.new(api, nil, nil, nil, split_sentences: '0')
        expect(request.options[:split_sentences]).to eq('0')
      end

      it 'leaves `nonewlines` as is' do
        request = described_class.new(api, nil, nil, nil, split_sentences: 'nonewlines')
        expect(request.options[:split_sentences]).to eq('nonewlines')
      end

      it 'leaves `1` as is' do
        request = described_class.new(api, nil, nil, nil, split_sentences: '1')
        expect(request.options[:split_sentences]).to eq('1')
      end

      it 'works with provided constants' do
        request = described_class.new(
          api,
          nil,
          nil,
          nil,
          split_sentences: DeepL::Constants::SplitSentences::SPLIT_ON_PUNCTUATION_AND_NEWLINES
        )
        expect(request.options[:split_sentences]).to eq('1')
      end
    end

    context 'when using `preserve_formatting` options' do
      it 'leaves `true` as is' do
        request = described_class.new(api, nil, nil, nil, preserve_formatting: true)
        expect(request.options[:preserve_formatting]).to be(true)
      end

      it 'leaves `false` as is' do
        request = described_class.new(api, nil, nil, nil, preserve_formatting: false)
        expect(request.options[:preserve_formatting]).to be(false)
      end

      it 'converts `0` to `false`' do
        request = described_class.new(api, nil, nil, nil, preserve_formatting: '0')
        expect(request.options[:preserve_formatting]).to be(false)
      end

      it 'converts `1` to `true`' do
        request = described_class.new(api, nil, nil, nil, preserve_formatting: '1')
        expect(request.options[:preserve_formatting]).to be(true)
      end
    end

    context 'when using `outline_detection` options' do
      it 'leaves `true` as is' do
        request = described_class.new(api, nil, nil, nil, outline_detection: true)
        expect(request.options[:outline_detection]).to be(true)
      end

      it 'leaves `false` as is' do
        request = described_class.new(api, nil, nil, nil, outline_detection: false)
        expect(request.options[:outline_detection]).to be(false)
      end

      it 'converts `0` to `false`' do
        request = described_class.new(api, nil, nil, nil, outline_detection: '0')
        expect(request.options[:outline_detection]).to be(false)
      end

      it 'converts `1` to `true`' do
        request = described_class.new(api, nil, nil, nil, outline_detection: '1')
        expect(request.options[:outline_detection]).to be(true)
      end
    end

    context 'when using `glossary_id` options' do
      it 'works with a nil values' do
        request = described_class.new(api, nil, nil, nil, glossary_id: nil)
        expect(request.options[:glossary_id]).to be_nil
      end

      it 'works with a string' do
        request = described_class.new(api, nil, nil, nil, glossary_id: 'sample_id')
        expect(request.options[:glossary_id]).to eq('sample_id')
      end
    end

    context 'when using `formality` options' do
      it 'works with a nil values' do
        request = described_class.new(api, nil, nil, nil, formality: nil)
        expect(request.options[:formality]).to be_nil
      end

      it 'works with a string' do
        request = described_class.new(api, nil, nil, nil, formality: 'more')
        expect(request.options[:formality]).to eq('more')
      end

      it 'works with provided constants' do
        request = described_class.new(api, nil, nil, nil,
                                      formality: DeepL::Constants::Formality::MORE)
        expect(request.options[:formality]).to eq('more')
      end
    end

    context 'when using `tag_handling_version` options' do
      it 'works with a nil value' do
        request = described_class.new(api, nil, nil, nil, tag_handling_version: nil)
        expect(request.options[:tag_handling_version]).to be_nil
      end

      it 'works with v1' do
        request = described_class.new(api, nil, nil, nil, tag_handling_version: 'v1')
        expect(request.options[:tag_handling_version]).to eq('v1')
      end

      it 'works with v2' do
        request = described_class.new(api, nil, nil, nil, tag_handling_version: 'v2')
        expect(request.options[:tag_handling_version]).to eq('v2')
      end
    end

    context 'when using `model_type` options' do
      it 'works with a nil value' do
        request = described_class.new(api, nil, nil, nil, model_type: nil)
        expect(request.options[:model_type]).to be_nil
      end

      it 'works with a string' do
        request = described_class.new(api, nil, nil, nil, model_type: 'latency_optimized')
        expect(request.options[:model_type]).to eq('latency_optimized')
      end

      it 'works with provided constants' do
        request = described_class.new(api, nil, nil, nil,
                                      model_type: DeepL::Constants::ModelType::LATENCY_OPTIMIZED)
        expect(request.options[:model_type]).to eq('latency_optimized')
      end
    end

    context 'when using `custom_instructions` options' do
      it 'works with a nil value' do
        request = described_class.new(api, nil, nil, nil, custom_instructions: nil)
        expect(request.options[:custom_instructions]).to be_nil
      end

      it 'works with an array of strings' do
        instructions = ['Use informal language', 'Be concise']
        request = described_class.new(api, nil, nil, nil, custom_instructions: instructions)
        expect(request.options[:custom_instructions]).to eq(instructions)
      end

      it 'works with a single string' do
        request = described_class.new(api, nil, nil, nil, custom_instructions: ['Be concise'])
        expect(request.options[:custom_instructions]).to eq(['Be concise'])
      end

      it 'works with a single string and converts it to an array' do
        instructions = 'Use informal language,Be concise'
        request = described_class.new(api, nil, nil, nil, custom_instructions: instructions)
        expect(request.options[:custom_instructions]).to eq(['Use informal language', 'Be concise'])
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('translate_texts') { example.call }
    end

    context 'when performing a valid request with one text' do
      it 'returns a text object' do
        text = translate.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Texto de muestra')
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a valid request with multiple texts' do
      let(:text) { %w[Sample Word] }

      it 'returns a text object' do
        texts = translate.request

        expect(texts).to be_a(Array)
        expect(texts.first.text).to eq('Muestra')
        expect(texts.first.detected_source_language).to eq('EN')

        expect(texts.last.text).to eq('Palabra')
        expect(texts.last.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a valid request with tag handling' do
      let(:text) { '<p>Sample text</p>' }
      let(:options) { { tag_handling: 'xml' } }

      it 'returns a text object' do
        text = translate.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('<p>Texto de muestra</p>')
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a valid request and passing a variable' do
      let(:text) { 'Welcome and <code>Hello great World</code> Good Morning!' }
      let(:options) { { tag_handling: 'xml', ignore_tags: %w[code span] } }

      it 'returns a text object' do
        text = translate.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Bienvenido y <code>Hello great World</code> ¡Buenos días!')
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a valid request with an HTML document' do
      let(:text) do
        <<~XML
          <document>
            <meta>
              <title>A document's title</title>
            </meta>
            <content>
              <par>This is the first sentence. Followed by a second one.</par>
              <par>This is the third sentence.</par>
            </content>
          </document>
        XML
      end
      let(:options) do
        {
          tag_handling: 'xml',
          split_sentences: 'nonewlines',
          outline_detection: false,
          splitting_tags: %w[title par]
        }
      end

      it 'returns a text object' do
        text = translate.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq(
          <<~XML
            <document>
              <meta>
                <title>Título de un documento</title>
              </meta>
              <content>
                <par>Es la primera frase. Seguido de una segunda.</par>
                <par>Esta es la tercera frase.</par>
              </content>
            </document>
          XML
        )
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a valid request with context' do
      let(:text) { 'That is hot!' }

      context 'when context is empty' do
        let(:options) { { context: '' } }

        it 'translates correctly with empty context' do
          res = translate.request
          expect(res).to be_a(DeepL::Resources::Text)
          expect(res.text).to eq('¡Eso está caliente!')
        end
      end

      context 'when context is set' do
        let(:options) { { context: 'He did not like the jalapenos in his meal.' } }

        it 'translates correctly with context taken into account' do
          res = translate.request
          expect(res).to be_a(DeepL::Resources::Text)
          expect(res.text).to eq('¡Eso es picante!')
        end
      end
    end

    context 'when performing a request with a model type' do
      let(:target_lang) { 'DE' }

      %w[quality_optimized latency_optimized prefer_quality_optimized].each do |model_type_str|
        it "translates correctly with #{model_type_str} models" do
          options = { model_type: model_type_str }
          translate = described_class.new(api, text, source_lang, target_lang, options)
          res = translate.request
          expect(res).to be_a(DeepL::Resources::Text)
          expected_model_type = model_type_str.sub(/^prefer_/, '')
          expect(res.model_type_used).to eq(expected_model_type)
        end
      end
    end

    context 'when performing a request with extra_body_parameters' do
      it 'allows extra parameters to override standard parameters' do
        extra_options = { extra_body_parameters: { target_lang: 'FR', debug: '1' } }
        translate = described_class.new(api, text, source_lang, target_lang, extra_options)
        res = translate.request

        expect(res).to be_a(DeepL::Resources::Text)
        expect(res.text).to eq('Texte modèle')
        expect(res.detected_source_language).to eq('EN')
      end
    end

    context 'when performing a request with custom_instructions' do
      let(:text) { 'Hello world' }
      let(:target_lang) { 'DE' }

      it 'includes custom_instructions in the payload' do
        options = { custom_instructions: ['Use formal language', 'Be concise'] }
        translate = described_class.new(api, text, source_lang, target_lang, options)

        # Verify the options are properly stored
        expect(translate.options[:custom_instructions]).to eq(['Use formal language', 'Be concise'])
      end
    end

    context 'when performing a request with tag_handling_version' do
      let(:text) { '<p>Hello world</p>' }
      let(:target_lang) { 'DE' }

      %w[v1 v2].each do |version|
        it "translates correctly with tag_handling_version #{version}" do
          options = { tag_handling: 'html', tag_handling_version: version }
          translate = described_class.new(api, text, source_lang, target_lang, options)
          res = translate.request

          expect(res).to be_a(DeepL::Resources::Text)
          expect(res.text).not_to be_nil
          expect(res.text).not_to be_empty
        end
      end
    end

    context 'when performing a bad request' do
      context 'when using an invalid token' do
        let(:api) do
          api = build_deepl_api
          api.configuration.auth_key = 'invalid'
          api
        end

        it 'raises an unauthorized error' do
          expect { translate.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
        end
      end

      context 'when using an invalid text' do
        let(:text) { nil }

        it 'raises a bad request error' do
          message = "Invalid request: Expected 'text' parameter to be an array of strings"
          expect { translate.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
        end
      end

      context 'when using an invalid target language' do
        let(:target_lang) { nil }

        it 'raises a bad request error' do
          message = "Value for 'target_lang' not supported."
          expect { translate.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
        end
      end
    end

    context 'when performing a request with too many texts' do
      let(:text) { Array.new(10_000) { |i| "This is the sentence number #{i}" } }

      it 'raises a request entity too large error' do
        expect { translate.request }.to raise_error(DeepL::Exceptions::RequestEntityTooLarge,
                                                    /request size has reached the supported limit/)
      end
    end
  end
end
