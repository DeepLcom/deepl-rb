# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe 'DeepL.usage', :mock_server_only do # rubocop:disable RSpec/DescribeClass
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  describe 'happy path' do
    it 'returns a Usage resource with integer counters where count does not exceed limit' do
      usage = DeepL.usage

      expect(usage).to be_a(DeepL::Resources::Usage)
      expect(usage).to respond_to(:character_count, :character_limit)
      expect(usage.character_count).to be_an(Integer)
      expect(usage.character_limit).to be_an(Integer)
      expect(usage.character_count).to be <= usage.character_limit
    end
  end

  describe 'resource shape' do
    it 'exposes quota_exceeded? consistent with character_count vs character_limit' do
      usage = DeepL.usage

      expect(usage).to respond_to(:quota_exceeded?)
      expect(usage.quota_exceeded?).to eq(usage.character_count >= usage.character_limit)
    end
  end
end
