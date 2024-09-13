# Copyright 2024 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class DocumentTranslationError < Error
      def initialize(message, handle)
        super(message)
        @handle = handle
      end
    end
  end
end
