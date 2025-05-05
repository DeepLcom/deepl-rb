# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class AuthorizationFailed < RequestError
      def to_s
        'Authorization failed. Please supply a valid auth_key parameter.'
      end
    end
  end
end
