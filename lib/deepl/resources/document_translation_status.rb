# frozen_string_literal: true

module DeepL
  module Resources
    class DocumentTranslationStatus < Base
      attr_reader :document_id, :status, :seconds_remaining, :billed_characters, :error_message

      def initialize(response, *args)
        super(*args)

        @document_id = response['document_id']
        @status = response['status']
        @seconds_remaining = response['seconds_remaining']
        @billed_characters = response['billed_characters']
        @error_message = response['error_message']
      end

      def to_s
        "DocumentTranslationStatus: ID: #{document_id} - Status: #{status} " \
          "- Error message: #{error_message}"
      end

      ##
      # Checks if the translation finished successfully
      #
      # @return [true] if so

      def successful?
        status == 'done'
      end

      ##
      # Checks if there was an error during translation
      #
      # @return [true] if so

      def error?
        status == 'error'
      end

      ##
      # Checks if the translation process terminated. Note that this could be due to an error as
      # well, but means no further waiting is necessary.
      #
      # @return [true] if so
      def finished?
        successful? || error?
      end
    end
  end
end
