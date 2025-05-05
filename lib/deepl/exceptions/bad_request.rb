# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class BadRequest < RequestError
      def to_s
        JSON.parse(response.body)['message']
      rescue JSON::ParserError
        response.body
      end
    end
  end
end
