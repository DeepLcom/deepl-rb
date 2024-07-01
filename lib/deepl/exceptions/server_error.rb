# frozen_string_literal: true

module DeepL
  module Exceptions
    class ServerError < RequestError
      def message
        'An internal server error occured. Try again after waiting a short period.'
      end

      def should_retry
        true
      end
    end
  end
end
