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

  def usage(options = {})
    configure if @configuration.nil?
    Requests::Usage.new(api, options).request
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
