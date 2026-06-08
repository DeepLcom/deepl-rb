# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe 'DeepL.translate', :mock_server_only do # rubocop:disable RSpec/DescribeClass
  include_context 'with a live mock server'

  let(:text) { 'proton beam' }

  describe 'happy path' do
    it 'translates a single string into a Text resource' do
      result = DeepL.translate(text, 'EN', 'DE')

      expect(result).to be_a(DeepL::Resources::Text)
      expect(result.text).to be_a(String)
      expect(result.text).not_to be_empty
    end

    it 'translates an array of strings into an array of Text resources' do
      results = DeepL.translate(%w[Sample Word], 'EN', 'ES')

      expect(results).to be_an(Array)
      expect(results.size).to eq(2)
      expect(results).to all(be_a(DeepL::Resources::Text))
    end
  end

  describe 'options' do
    it 'accepts a formality setting' do
      result = DeepL.translate('How are you?', 'EN', 'DE', { formality: 'more' })

      expect(result).to be_a(DeepL::Resources::Text)
    end

    it 'translates with XML tag handling and ignored tags' do
      result = DeepL.translate('<p>Sample <code>x</code></p>', 'EN', 'ES',
                               { tag_handling: 'xml', ignore_tags: %w[code] })

      expect(result.text).to be_a(String)
      expect(result.text).not_to be_empty
    end

    it 'accepts a context option' do
      result = DeepL.translate('That is hot!', 'EN', 'ES', { context: 'about the weather' })

      expect(result).to be_a(DeepL::Resources::Text)
    end
  end
end
