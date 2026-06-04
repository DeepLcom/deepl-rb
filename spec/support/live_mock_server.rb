# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

# Shared setup for integration error-path specs that hit the live mock server:
# bypass VCR, allow real connections, and expose an API the server rejects as
# unauthorized without mutating global DeepL state.
RSpec.shared_context 'with a live mock server' do
  before do
    VCR.turn_off!
    WebMock.allow_net_connect!
  end

  after do
    VCR.turn_on!
    WebMock.disable_net_connect!
  end

  let(:unauthorized_api) do
    DeepL::API.new(DeepL::Configuration.new(auth_key: 'invalid'))
  end
end
