# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe 'DeepL.rephrase', :mock_server_only do # rubocop:disable RSpec/DescribeClass
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  describe 'happy path' do
    it 'rephrases an English sentence into English and returns a Text resource' do
      result = DeepL.rephrase('As Gregor Samsa awoke one morning he found himself transformed.',
                              'en')

      expect(result).to be_a(DeepL::Resources::Text)
      expect(result.text).to be_a(String)
      expect(result.text).not_to be_empty
    end
  end

  describe 'error path' do
    it 'raises a bad request error for an invalid writing_style value' do
      expect do
        DeepL.rephrase('As Gregor Samsa awoke one morning he found himself transformed.',
                       'en', 'totally_invalid_style')
      end.to raise_error(DeepL::Exceptions::BadRequest)
    end
  end

  describe 'edge case' do
    it 'rephrases with a writing_style option applied' do
      result = DeepL.rephrase('As Gregor Samsa awoke one morning he found himself transformed.',
                              'en', 'business')

      expect(result).to be_a(DeepL::Resources::Text)
      expect(result.text).to be_a(String)
      expect(result.text).not_to be_empty
    end

    it 'rephrases an array of texts and returns an array of Text resources' do
      texts = [
        'As Gregor Samsa awoke one morning he found himself transformed.',
        'He lay on his armour-like back, and if he lifted his head a little.'
      ]

      results = DeepL.rephrase(texts, 'en')

      expect(results).to be_an(Array)
      expect(results.size).to eq(2)
      expect(results).to all(be_a(DeepL::Resources::Text))
      expect(results.map(&:text)).to all(be_a(String).and(satisfy { |t| !t.empty? }))
    end
  end
end
