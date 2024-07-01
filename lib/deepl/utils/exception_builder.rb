# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Utils
    class ExceptionBuilder
      attr_reader :request, :response

      ERROR_CODE_CLASS_MAP = {
        '400' => Exceptions::BadRequest,
        '401' => Exceptions::AuthorizationFailed,
        '403' => Exceptions::AuthorizationFailed,
        '404' => Exceptions::NotFound,
        '413' => Exceptions::RequestEntityTooLarge,
        '429' => Exceptions::LimitExceeded,
        '456' => Exceptions::QuotaExceeded,
        '500' => Exceptions::ServerError
      }.freeze

      def initialize(response)
        @response = response
      end

      def build
        error_class = ERROR_CODE_CLASS_MAP[response.code.to_s] || Exceptions::RequestError
        error_class.new(response)
      end
    end
  end
end
