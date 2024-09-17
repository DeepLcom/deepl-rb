# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class NotFound < RequestError
      def message
        JSON.parse(response.body)['message']
      rescue JSON::ParserError
        response.body
      end
    end
  end
end
