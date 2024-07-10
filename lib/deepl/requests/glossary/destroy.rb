# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Requests
    module Glossary
      class Destroy < Base
        attr_reader :id

        def initialize(api, id, options = {})
          super(api, options)
          @id = id
        end

        def request
          build_response(*execute_request_with_retries(delete_request))
        end

        def to_s
          "DELETE #{uri.request_uri}"
        end

        private

        def build_response(_, _)
          id
        end

        def path
          "glossaries/#{id}"
        end
      end
    end
  end
end
