# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

require 'spec_helper'

describe DeepL::StyleRuleApi, :mock_server_only do # rubocop:disable RSpec/SpecFilePathFormat
  include_context 'with a live mock server'

  let(:missing_uuid) { '00000000-0000-0000-0000-000000000000' }

  describe 'authorization failures' do
    let(:unauthorized_style_rules) { described_class.new(unauthorized_api) }

    it 'raises AuthorizationFailed on a read operation (list)' do
      expect { unauthorized_style_rules.list }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end

    it 'raises AuthorizationFailed on a write operation (create)' do
      expect { unauthorized_style_rules.create('Auth Failure Test', 'en') }
        .to raise_error(DeepL::Exceptions::AuthorizationFailed)
    end
  end

  describe 'not-found failures' do
    it 'raises NotFound when #find is called with a missing UUID' do
      expect { DeepL.style_rules.find(missing_uuid) }
        .to raise_error(DeepL::Exceptions::NotFound)
    end
  end

  describe 'bad-request failures' do
    it 'raises BadRequest when create is called with a nil language' do
      expect { DeepL.style_rules.create('Nil Lang', nil) }
        .to raise_error(DeepL::Exceptions::BadRequest)
    end
  end
end
