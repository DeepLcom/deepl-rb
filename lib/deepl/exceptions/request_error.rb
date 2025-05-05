# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class RequestError < Error
      attr_reader :request, :response

      def initialize(response)
        super()
        @response = response
      end

      def to_s
        'Unknown error.'
      end
    end
  end
end
