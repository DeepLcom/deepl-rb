# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Language do
  subject(:language) { described_class.new('EN', 'English', nil, nil, nil) }

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(language).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(language.code).to eq('EN')
        expect(language.name).to eq('English')
      end

      it 'does not define the supports formality method' do
        expect { language.supports_formality? }.to raise_error(DeepL::Exceptions::NotSupported)
      end
    end

    context 'when building a target language object' do
      subject(:language) { described_class.new('EN', 'English', true, nil, nil) }

      it 'creates a resource' do
        expect(language).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(language.code).to eq('EN')
        expect(language.name).to eq('English')
      end

      it 'includes the supports formality method' do
        expect { language.supports_formality? }.not_to raise_error
        expect(language).to be_supports_formality
      end
    end
  end
end
