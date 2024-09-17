# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::LanguagePair do
  subject(:language_pair) { described_class.new('en', 'de', nil, nil) }

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(language_pair).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(language_pair.source_lang).to eq('en')
        expect(language_pair.target_lang).to eq('de')
      end
    end
  end
end
