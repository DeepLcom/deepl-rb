# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Requests
    class Base # rubocop:disable Metrics/ClassLength
      attr_reader :api, :response, :options

      def initialize(api, options = {})
        @api = api
        @options = options
        @num_retries = 0
        @backoff_timer = Utils::BackoffTimer.new
      end

      def request
        raise NotImplementedError
      end

      def details
        "HTTP Headers #{headers}"
      end

      private

      def option?(name)
        options.key?(name.to_s) || options.key?(name.to_sym)
      end

      def option(name)
        options[name.to_s] || options[name.to_sym]
      end

      def delete_option(name)
        options.delete(name.to_s) || options.delete(name.to_sym)
      end

      def set_option(name, value)
        if options.key?(name.to_sym)
          options[name.to_sym] = value
        else
          options[name.to_s] = value
        end
      end

      def execute_request_with_retries(req)
        loop do
          resp = api.http_client.request(req)
          validate_response!(req, resp)
          return [req, resp]
        rescue DeepL::Exceptions::Error => e
          raise e unless should_retry?(resp, e, @backoff_timer.num_retries)

          backoff_timer.sleep_until_deadline
          next
        end
      end

      def should_retry?(response, exception, num_retries)
        return false if num_retries >= api.configuration.max_network_retries
        return exception.should_retry? if response.nil?

        response.is_a?(Net::HTTPTooManyRequests) || response.is_a?(Net::HTTPInternalServerError)
      end

      def post_request(payload)
        http_headers = add_json_content_type(headers)
        post_req = Net::HTTP::Post.new(uri.path, http_headers)
        post_req.body = payload.merge(options).to_json
        post_req
      end

      def post_request_with_file(form_data)
        http_headers = add_multipart_form_content_type(headers)
        post_req = Net::HTTP::Post.new(uri.request_uri, http_headers)
        # options are passed in `form_data`
        form_data += options.map { |key, value| [key.to_s, value.to_s] }
        post_req.set_form(form_data, 'multipart/form-data')
        post_req
      end

      def get_request # rubocop:disable Naming/AccessorMethodName
        http_headers = add_json_content_type(headers)
        get_req = Net::HTTP::Get.new(uri.path, http_headers)
        get_req.body = options.to_json
        get_req
      end

      def delete_request
        http_headers = add_json_content_type(headers)
        del_req = Net::HTTP::Delete.new(uri.path, http_headers)
        del_req.body = options.to_json
        del_req
      end

      def validate_response!(response)
        return if response.is_a?(Net::HTTPSuccess)

        raise Utils::ExceptionBuilder.new(response).build
      end

      def path
        raise NotImplementedError
      end

      def url
        "#{host}/#{api.configuration.version}/#{path}"
      end

      def uri
        @uri ||= URI(url)
        @uri
      end

      def host
        api.configuration.host
      end

      def query_params
        options
      end

      def headers
        { 'Authorization' => "DeepL-Auth-Key #{api.configuration.auth_key}" }
      end

      def add_json_content_type(headers_to_add_to)
        headers_to_add_to['Content-Type'] = 'application/json'
        headers_to_add_to
      end

      def add_multipart_form_content_type(headers_to_add_to)
        headers_to_add_to['Content-Type'] = 'multipart/form-data'
        headers_to_add_to
      end
    end
  end
end
