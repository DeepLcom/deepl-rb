# frozen_string_literal: true

module DeepL
  module Requests
    module Document
      class Upload < Base
        attr_reader :input_file_path, :source_lang, :target_lang, :filename

        SUPPORTED_OPTIONS = %w[formality glossary_id output_format].freeze

        def initialize(api, input_file_path, source_lang, target_lang, filename = nil,
                       options = {})
          super(api, options)
          @input_file_path = input_file_path
          @source_lang = source_lang
          @target_lang = target_lang
          @filename = filename
        end

        def request # rubocop:disable Metrics/AbcSize
          form_data = [
            ['file', File.open(input_file_path, 'rb')], ['source_lang', source_lang],
            ['target_lang', target_lang]
          ]
          filename_param = filename || File.basename(input_file_path)
          form_data.push(['filename', filename_param]) unless filename_param.nil?
          # Manually add options due to multipart/form-data request
          SUPPORTED_OPTIONS.each do |option|
            form_data.push([option, options[option]]) unless options[option].nil?
          end
          build_doc_handle(*post_with_file(form_data))
        end

        private

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
