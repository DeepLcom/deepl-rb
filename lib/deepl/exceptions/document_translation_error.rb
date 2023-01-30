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
