# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Rephrase do
  subject(:rephrase) { described_class.new(api, text, target_lang, writing_style, tone, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:text) do
    'As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed.'
  end
  let(:target_lang) { 'EN' }
  let(:writing_style) { nil }
  let(:tone) { nil }
  let(:options) { {} }

  describe '#request' do
    around do |example|
      VCR.use_cassette('rephrase_texts') { example.call }
    end

    context 'without a style or tone applied' do
      context 'with a string as input' do
        it 'returns a valid response as a DeepL Text resource' do
          original_length = text.length
          response_text = rephrase.request

          expect(response_text).to be_a(DeepL::Resources::Text)
          expect(response_text.text.length).not_to eq(original_length)
          expect(response_text.detected_source_language.upcase).to eq('EN')
        end
      end

      context 'with an array of texts as input' do
        let(:text) do
          [
            'As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed.',
            'He lay on his armour-like back, and if he lifted his head a little'
          ]
        end

        it 'returns a valid response as an array of DeepL Text resources' do
          response_texts = rephrase.request

          expect(response_texts).to all(be_a(DeepL::Resources::Text))
          response_texts.each_with_index do |response_text, index|
            expect(response_text.text.length).not_to eq(text[index].length)
            expect(response_text.detected_source_language.upcase).to eq('EN')
          end
        end
      end
    end

    context 'with a valid tone applied' do
      let(:tone) { 'friendly' }

      context 'with a string as input' do
        it 'returns a valid response with a string as text input' do
          original_length = text.length
          response_text = rephrase.request

          expect(response_text).to be_a(DeepL::Resources::Text)
          expect(response_text.text.length).not_to eq(original_length)
          expect(response_text.detected_source_language.upcase).to eq('EN')
        end
      end

      context 'with an array of texts as input' do
        let(:text) do
          [
            'As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed.',
            'He lay on his armour-like back, and if he lifted his head a little'
          ]
        end

        it 'returns an array of valid text objects' do
          response_texts = rephrase.request

          expect(response_texts).to all(be_a(DeepL::Resources::Text))
          response_texts.each_with_index do |response_text, index|
            expect(response_text.text.length).not_to eq(text[index].length)
            expect(response_text.detected_source_language.upcase).to eq('EN')
          end
        end
      end
    end

    context 'with a valid writing style applied' do
      let(:writing_style) { 'business' }

      context 'with a string as input' do
        it 'returns a valid response with a string as text input' do
          original_length = text.length
          response_text = rephrase.request

          expect(response_text).to be_a(DeepL::Resources::Text)
          expect(response_text.text.length).not_to eq(original_length)
          expect(response_text.detected_source_language.upcase).to eq('EN')
        end
      end

      context 'with an array of texts as input' do
        let(:text) do
          [
            'As Gregor Samsa awoke one morning from uneasy dreams he found himself transformed.',
            'He lay on his armour-like back, and if he lifted his head a little'
          ]
        end

        it 'returns an array of valid text objects' do
          response_texts = rephrase.request

          expect(response_texts).to all(be_a(DeepL::Resources::Text))
          response_texts.each_with_index do |response_text, index|
            expect(response_text.text.length).not_to eq(text[index].length)
            expect(response_text.detected_source_language.upcase).to eq('EN')
          end
        end
      end
    end

    context 'with a writing style or tone from the provided constants applied' do
      let(:writing_style) { DeepL::Constants::WritingStyle::BUSINESS }
      let(:tone) { DeepL::Constants::Tone::FRIENDLY }

      it 'has the correct writing style and tone applied' do
        expect(rephrase.writing_style).to eq('business')
        expect(rephrase.tone).to eq('friendly')
      end
    end

    context 'with an invalid writing style applied' do
      let(:writing_style) { 'angry' }

      it 'raises a bad request error' do
        expect { rephrase.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end

    context 'when both writing style and tone are applied' do
      let(:writing_style) { 'business' }
      let(:tone) { 'friendly' }

      it 'raises a bad request error' do
        expect { rephrase.request }.to raise_error(DeepL::Exceptions::BadRequest)
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
          expect { rephrase.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
        end
      end
    end
  end
end
