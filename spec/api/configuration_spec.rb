# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Configuration do
  subject(:config) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#initialize' do
    context 'when using default configuration attributes' do
      it 'uses default attributes' do
        expect(config.auth_key).to eq(ENV.fetch('DEEPL_AUTH_KEY', nil))
        expect(config.host).to eq('https://api.deepl.com')
        expect(config.version).to eq('v2')
      end
    end

    context 'when using custom configuration attributes' do
      let(:attributes) { { auth_key: 'SAMPLE', host: 'https://api-free.deepl.com', version: 'v1' } }

      it 'uses custom attributes' do
        expect(config.auth_key).to eq(attributes[:auth_key])
        expect(config.host).to eq(attributes[:host])
        expect(config.version).to eq(attributes[:version])
      end
    end
  end

  describe '#validate!' do
    let(:auth_message) { 'auth_key not provided' }

    context 'when providing a valid auth key' do
      let(:attributes) { { auth_key: '' } }

      it 'raises an error' do
        expect { config.validate! }.to raise_error(DeepL::Exceptions::Error, auth_message)
      end
    end

    context 'when providing an invalid auth key' do
      let(:attributes) { { auth_key: 'not-empty' } }

      it 'does not raise an error' do
        expect { config.validate! }.not_to raise_error
      end
    end
  end
end
