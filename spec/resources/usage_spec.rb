# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Usage do
  subject(:usage) { described_class.new(3, 5, nil, nil) }

  describe '#initialize' do
    context 'when building a basic object' do
      it 'creates a resource' do
        expect(usage).to be_a(described_class)
      end

      it 'assigns the attributes' do
        expect(usage.character_count).to eq(3)
        expect(usage.character_limit).to eq(5)
      end

      it 'does not exceed the quota' do
        expect(usage).not_to be_quota_exceeded
      end
    end

    context 'when building a quota exceeded object' do
      subject(:usage) { described_class.new(5, 5, nil, nil) }

      it 'exceeds the quota' do
        expect(usage).to be_quota_exceeded
      end
    end
  end
end
