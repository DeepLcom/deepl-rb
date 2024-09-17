# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::LanguagePairs do
  subject(:language_pairs_obj) { described_class.new(api, options) }

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(language_pairs_obj).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'when requesting a list of all language pairs supported by glossaries' do
      it 'returns a language pairs object' do
        language_pairs = language_pairs_obj.request
        expect(language_pairs).to be_an(Array)
      end
    end
  end
end
