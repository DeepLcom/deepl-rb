# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Languages do
  subject(:languages_obj) { described_class.new(api, options) }

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
        expect(languages_obj).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('languages') { example.call }
    end

    context 'when requesting source languages' do
      it 'returns a valid list of source languages' do
        languages = languages_obj.request

        expect(languages).to be_an(Array)
        expect(languages.size).to eq(29)
        expect(languages).to(be_any { |l| l.code == 'EN' && l.name == 'English' })
        expect(languages).to(be_any { |l| l.code == 'ES' && l.name == 'Spanish' })
      end
    end

    context 'when requesting target languages' do
      let(:options) { { type: :target } }

      it 'returns a valid list of target languages' do
        languages = languages_obj.request

        expect(languages).to be_an(Array)
        expect(languages.size).to eq(31)
        expect(languages).not_to(be_any { |l| l.code == 'EN' && l.name == 'English' })
        expect(languages).to(be_any { |l| l.code == 'ES' && l.name == 'Spanish' })
        expect(languages)
          .to(be_any { |l| l.code == 'EN-US' && l.name == 'English (American)' })
      end
    end

    context 'when using an invalid type' do
      let(:options) { { type: :invalid } }

      it 'returns an usage object' do
        message = "Parameter 'type' is invalid. 'source' and 'target' are valid values."
        expect { languages_obj.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
      end
    end
  end
end
