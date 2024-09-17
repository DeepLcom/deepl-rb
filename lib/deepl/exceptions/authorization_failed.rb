# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class AuthorizationFailed < RequestError
      def message
        'Authorization failed. Please supply a valid auth_key parameter.'
      end
    end
  end
end
