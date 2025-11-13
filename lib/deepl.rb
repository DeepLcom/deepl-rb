# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

# -- Dependencies
require 'json'
require 'net/http'

# -- Exceptions
require 'deepl/exceptions/error'
require 'deepl/exceptions/request_error'
require 'deepl/exceptions/authorization_failed'
require 'deepl/exceptions/bad_request'
require 'deepl/exceptions/limit_exceeded'
require 'deepl/exceptions/quota_exceeded'
require 'deepl/exceptions/not_found'
require 'deepl/exceptions/not_supported'
require 'deepl/exceptions/request_entity_too_large'
require 'deepl/exceptions/document_translation_error'
require 'deepl/exceptions/server_error'

# -- Requests
require 'deepl/requests/base'
require 'deepl/requests/document/download'
require 'deepl/requests/document/get_status'
require 'deepl/requests/document/upload'
require 'deepl/requests/glossary/create'
require 'deepl/requests/glossary/destroy'
require 'deepl/requests/glossary/entries'
require 'deepl/requests/glossary/find'
require 'deepl/requests/glossary/language_pairs'
require 'deepl/requests/glossary/list'
require 'deepl/requests/languages'
require 'deepl/requests/translate'
require 'deepl/requests/usage'
require 'deepl/requests/rephrase'

# -- Responses and resources
require 'deepl/resources/base'
require 'deepl/resources/document_handle'
require 'deepl/resources/document_translation_status'
require 'deepl/resources/glossary'
require 'deepl/resources/language'
require 'deepl/resources/language_pair'
require 'deepl/resources/text'
require 'deepl/resources/usage'

# -- Utils
require 'deepl/utils/exception_builder'
require 'deepl/utils/backoff_timer'

# -- Constants
require 'deepl/constants/base_constant'
require 'deepl/constants/formality'
require 'deepl/constants/model_type'
require 'deepl/constants/split_sentences'
require 'deepl/constants/tag_handling'
require 'deepl/constants/tone'
require 'deepl/constants/writing_style'

# -- HTTP Utils
require 'http_client_options'

# -- Version
require 'version'

# -- Other wrappers
require 'deepl/api'
require 'deepl/configuration'
require 'deepl/document_api'
require 'deepl/glossary_api'

# -- Gem interface
module DeepL
  extend self

  ## -- API shortcuts

  def api
    @api ||= API.new(configuration)
  end

  def languages(options = {})
    Requests::Languages.new(api, options).request
  end

  def translate(text, source_lang, target_lang, options = {})
    configure if @configuration.nil?
    Requests::Translate.new(api, text, source_lang, target_lang, options).request
  end

  def document(options = {})
    configure if @configuration.nil?
    DocumentApi.new(api, options)
  end

  def glossaries(options = {})
    configure if @configuration.nil?
    GlossaryApi.new(api, options)
  end

  def rephrase(text, target_lang = nil, writing_style = nil, tone = nil, options = {}) # rubocop:disable Metrics/ParameterLists
    configure if @configuration.nil?
    Requests::Rephrase.new(api, text, target_lang, writing_style, tone, options).request
  end

  def usage(options = {})
    configure if @configuration.nil?
    Requests::Usage.new(api, options).request
  end

  def http_client
    @http_client
  end

  def with_session(client_options = HTTPClientOptions.new()) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    raise ArgumentError 'This method requires a block to be passed in which contains the actual API calls, see README for example usage.' unless block_given? # rubocop:disable Layout/LineLength

    has_proxy = client_options.proxy.key?('proxy_addr') and client_options.proxy.key?('proxy_port')
    begin
      uri = URI(configuration.host)
      http = Net::HTTP.new(uri.host, uri.port, has_proxy ? client_options.proxy['proxy_addr'] : nil,
                           has_proxy ? client_options.proxy['proxy_port'] : nil)
      http.use_ssl = client_options.enable_ssl_verification
      http.ca_file = client_options.cert_path if client_options.cert_path
      http.open_timeout = client_options.open_timeout unless client_options.open_timeout.nil?
      http.read_timeout = client_options.read_timeout unless client_options.read_timeout.nil?
      http.write_timeout = client_options.write_timeout unless client_options.write_timeout.nil?
      http.ssl_timeout = client_options.ssl_timeout unless client_options.ssl_timeout.nil?
      http.start
      @http_client = http
      api.update_http_client(http)
      yield
    ensure
      http.finish
    end
  end

  # -- Configuration

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
    configuration.validate!
  end
end
