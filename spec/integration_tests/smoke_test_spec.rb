# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe 'SDK smoke test', :integration, :mock_server_only do # rubocop:disable RSpec/DescribeClass
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  it 'exercises translate, glossaries.list, and usage end-to-end' do # rubocop:disable RSpec/ExampleLength
    source_text = 'Hello, world!'
    result = DeepL.translate(source_text, 'EN', 'DE')
    expect(result).to be_a(DeepL::Resources::Text)
    expect(result.text).to be_a(String)
    expect(result.text).not_to be_empty
    expect(result.text).not_to eq(source_text)

    glossaries = DeepL.glossaries.list
    expect(glossaries).to be_an(Array)

    usage = DeepL.usage
    expect(usage).to be_a(DeepL::Resources::Usage)
    expect(usage).to respond_to(:character_count, :character_limit)
  end
end
