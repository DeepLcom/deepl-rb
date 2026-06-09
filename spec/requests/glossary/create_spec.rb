# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Create do
  subject(:create) do
    described_class.new(api, name, source_lang, target_lang, entries, options)
  end

  around do |tests|
    tmp_env = replace_env_preserving_deepl_vars_except_mock_server
    tests.call
    ENV.replace(tmp_env)
  end

  let(:api) { build_deepl_api }
  let(:name) { 'Mi Glosario' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  let(:entries) do
    [
      %w[Hello Hola],
      %w[World Mundo]
    ]
  end
  let(:options) { {} }

  describe '#initialize' do
    context 'when building a request' do
      it 'creates a request object' do
        expect(create).to be_a(described_class)
      end

      it 'sets the default value for the entries format if not specified' do
        request = described_class.new(api, name, source_lang, target_lang,
                                      entries, options)
        expect(request.entries_format).to eq('tsv')
      end
    end
  end
end
