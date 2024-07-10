# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Find < Base
        attr_reader :id

        def initialize(api, id, options = {})
          super(api, options)
          @id = id
        end

        def request
          build_glossary(*execute_request_with_retries(get_request))
        end

        def to_s
          "GET #{uri.request_uri}"
        end

        private

        def build_glossary(request, response)
          glossary = JSON.parse(response.body)
          Resources::Glossary.new(glossary, request, response)
        end

        def path
          "glossaries/#{id}"
        end
      end
    end
  end
end
