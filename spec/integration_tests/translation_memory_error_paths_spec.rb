# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::TranslationMemoryApi, :mock_server_only do # rubocop:disable RSpec/SpecFilePathFormat
  include_context 'with a live mock server'

  describe 'authorization failures' do
    let(:unauthorized_translation_memories) { described_class.new(unauthorized_api) }

    it 'raises AuthorizationFailed when listing with an invalid auth key' do
      expect { unauthorized_translation_memories.list }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end
end
