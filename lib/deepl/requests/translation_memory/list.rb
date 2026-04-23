# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Requests
    module TranslationMemory
      class List < Base
        def initialize(api, options = {})
          super
        end

        def request
          build_translation_memory_list(*execute_request_with_retries(get_request))
        end

        def to_s
          "GET #{uri.request_uri}"
        end

        private

        def get_request # rubocop:disable Naming/AccessorMethodName
          http_headers = add_json_content_type(headers)
          Net::HTTP::Get.new(uri.request_uri, http_headers)
        end

        def build_translation_memory_list(request, response)
          data = JSON.parse(response.body)
          data['translation_memories'].map do |tm|
            Resources::TranslationMemory.new(tm, request, response)
          end
        end

        def uri
          @uri ||= begin
            base_uri = URI("#{host}/v3/#{path}")
            query_string = build_query_string
            base_uri.query = query_string unless query_string.empty?
            base_uri
          end
        end

        def build_query_string
          params = {}
          params['page'] = option(:page).to_s if option?(:page)
          params['page_size'] = option(:page_size).to_s if option?(:page_size)
          URI.encode_www_form(params)
        end

        def path
          'translation_memories'
        end
      end
    end
  end
end
