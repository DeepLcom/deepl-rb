# Copyright 2021 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Requests
    class Languages < Base
      def initialize(api, options = {})
        super
      end

      def request
        build_languages(*execute_request_with_retries(get_request))
      end

      def to_s
        "GET #{uri.request_uri}"
      end

      private

      def build_languages(request, response)
        data = JSON.parse(response.body)
        data.map do |language|
          Resources::Language.new(language['language'], language['name'],
                                  language['supports_formality'],
                                  request, response)
        end
      end

      def path
        'languages'
      end
    end
  end
end
