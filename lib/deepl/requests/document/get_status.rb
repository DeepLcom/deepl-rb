# frozen_string_literal: true

module DeepL
  module Requests
    module Document
      class GetStatus < Base
        attr_reader :document_id, :document_key

        def initialize(api, document_id, document_key, options = {})
          super(api, options)
          @document_id = document_id
          @document_key = document_key
        end

        def request
          payload = { document_key: document_key }
          build_doc_translation_status(*execute_request_with_retries(post_request(payload)))
        end

        private

        def build_doc_translation_status(request, response)
          document_translation_status = JSON.parse(response.body)
          Resources::DocumentTranslationStatus.new(document_translation_status, request, response)
        end

        def path
          "document/#{document_id}"
        end
      end
    end
  end
end
