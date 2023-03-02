# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  class Configuration
    ATTRIBUTES = %i[auth_key host version].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize(data = {})
      data.each { |key, value| send("#{key}=", value) }
      @auth_key ||= ENV.fetch('DEEPL_AUTH_KEY', nil)
      @host ||= 'https://api.deepl.com'
      @version ||= 'v2'
    end

    def validate!
      raise Exceptions::Error, 'auth_key not provided' if auth_key.nil? || auth_key.empty?
    end

    def attributes
      ATTRIBUTES.to_h { |attr| [attr, send(attr)] }
    end

    def ==(other)
      attributes == other.attributes
    end
  end
end
