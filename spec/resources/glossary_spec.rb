# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Glossary do
  subject(:glossary) do
    described_class.new({
                          'glossary_id' => 'def3a26b-3e84-45b3-84ae-0c0aaf3525f7',
                          'name' => 'Mein Glossar',
                          'ready' => true,
                          'source_lang' => 'EN',
                          'target_lang' => 'DE',
                          'creation_time' => '2021-08-03T14:16:18.329Z',
                          'entry_count' => 1
                        }, nil, nil)
  end

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(glossary).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(glossary.id).to eq('def3a26b-3e84-45b3-84ae-0c0aaf3525f7')
        expect(glossary.name).to eq('Mein Glossar')
        expect(glossary.ready).to be(true)
        expect(glossary.source_lang).to eq('EN')
        expect(glossary.target_lang).to eq('DE')
        expect(glossary.creation_time).to eq('2021-08-03T14:16:18.329Z')
        expect(glossary.entry_count).to eq(1)
      end
    end
  end
end
