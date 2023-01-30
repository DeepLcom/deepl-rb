# frozen_string_literal: true

module DeepL
  module Requests
    module Document
      class Download < Base
        attr_reader :document_id, :document_key

        def initialize(api, document_id, document_key, output_file)
          super(api, {})
          @document_id = document_id
          @document_key = document_key
          @output_file = output_file
        end

        def request
          payload = { document_key: document_key }
          extract_file(*post(payload))
        end

        private

        def extract_file(_request, response)
          File.write(@output_file, response.body)
        end

        def path
          "document/#{document_id}/result"
        end
      end
    end
  end
end