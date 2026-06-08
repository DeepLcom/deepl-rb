# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

require 'spec_helper'

describe 'DeepL.translate error paths', :mock_server_only do # rubocop:disable RSpec/DescribeClass
  include_context 'with a live mock server'

  let(:text) { 'proton beam' }

  describe 'authorization failures' do
    it 'raises AuthorizationFailed when the auth key is invalid' do
      request = DeepL::Requests::Translate.new(unauthorized_api, text, 'EN', 'DE')

      expect { request.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end

  describe 'bad request errors' do
    it 'raises BadRequest for an unsupported target language' do
      expect { DeepL.translate(text, 'EN', 'ZZ') }
        .to raise_error(DeepL::Exceptions::BadRequest)
    end

    it 'raises BadRequest when no target language is given' do
      expect { DeepL.translate(text, 'EN', nil) }
        .to raise_error(DeepL::Exceptions::BadRequest)
    end
  end
end
