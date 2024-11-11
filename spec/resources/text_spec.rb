# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Text do
  subject(:text) { described_class.new('Target', 'es', nil, nil, nil) }

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(text).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(text.text).to eq('Target')
        expect(text.detected_source_language).to eq('es')
      end
    end
  end
end
