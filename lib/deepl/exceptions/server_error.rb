# Copyright 2024 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class ServerError < RequestError
      def to_s
        'An internal server error occured. Try again after waiting a short period.'
      end

      def should_retry?
        true
      end
    end
  end
end
