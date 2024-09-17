# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Resources
    class Base
      attr_reader :request, :response

      def initialize(request, response)
        @request = request
        @response = response
      end
    end
  end
end
