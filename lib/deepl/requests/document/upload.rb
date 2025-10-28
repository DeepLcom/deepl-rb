# Copyright 2024 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

module DeepL
  module Requests
    module Document
      class Upload < Base
        attr_reader :input_file_path, :source_lang, :target_lang, :filename

        SUPPORTED_OPTIONS = %w[formality glossary_id output_format].freeze

        def initialize(api, input_file_path, source_lang, target_lang, filename = nil, # rubocop:disable Metrics/ParameterLists
                       options = {}, additional_headers = {})
          super(api, options, additional_headers)
          @input_file_path = input_file_path
          @source_lang = source_lang
          @target_lang = target_lang
          @filename = filename
        end

        def request
          input_file = File.open(input_file_path, 'rb')
          form_data = build_base_form_data(input_file)
          apply_extra_body_parameters_to_form(form_data)
          build_doc_handle(*execute_request_with_retries(post_request_with_file(form_data),
                                                         [input_file]))
        end

        def details
          "HTTP Headers: #{headers}\nPayload #{[
            ['file', "File at #{input_file_path} opened in binary mode"],
            ['source_lang', source_lang], ['target_lang', target_lang], ['filename', filename]
          ]}"
        end

        def to_s
          "POST #{uri.request_uri}"
        end

        private

        def build_base_form_data(input_file)
          form_data = [
            ['file', input_file], ['source_lang', source_lang],
            ['target_lang', target_lang]
          ]
          filename_param = filename || File.basename(input_file_path)
          form_data.push(['filename', filename_param]) unless filename_param.nil?
          add_supported_options_to_form(form_data)
          form_data
        end

        def add_supported_options_to_form(form_data)
          SUPPORTED_OPTIONS.each do |option_name|
            option_value = option(option_name)
            form_data.push([option_name, option_value]) unless option_value.nil?
          end
        end

        def build_doc_handle(request, response)
          parsed_response = JSON.parse(response.body)
          Resources::DocumentHandle.new(parsed_response['document_id'],
                                        parsed_response['document_key'], request, response)
        end

        def path
          'document'
        end
      end
    end
  end
end
