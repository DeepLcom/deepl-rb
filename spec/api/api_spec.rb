# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::API do
  subject(:api) { described_class.new(configuration) }

  let(:configuration) { DeepL::Configuration.new }

  describe '#initialize' do
    context 'when building an API object' do
      it 'saves the configuration' do
        expect(api.configuration).to be(configuration)
      end
    end
  end
end
