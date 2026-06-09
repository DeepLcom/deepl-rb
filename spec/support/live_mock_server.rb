# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

# Shared setup for integration specs that hit the live mock server: expose an
# API the server rejects as unauthorized without mutating global DeepL state.
RSpec.shared_context 'with a live mock server' do
  let(:unauthorized_api) do
    DeepL::API.new(DeepL::Configuration.new(auth_key: 'invalid'))
  end
end
