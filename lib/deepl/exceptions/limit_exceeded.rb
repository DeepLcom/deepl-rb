# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class LimitExceeded < RequestError
      def message
        'Limit exceeded. Please wait and send your request once again.'
      end

      def should_retry?
        true
      end
    end
  end
end
