# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Usage do
  subject(:usage_req) { described_class.new(api, options) }

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
        expect(usage_req).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('usage') { example.call }
    end

    context 'when performing a valid request' do
      it 'returns an usage object' do
        usage = usage_req.request

        expect(usage).to be_a(DeepL::Resources::Usage)
        expect(usage.character_count).to be_a(Numeric)
        expect(usage.character_limit).to be_a(Numeric)
      end
    end
  end
end
