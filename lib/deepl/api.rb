# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  class API
    attr_reader :configuration, :http_client

    def initialize(configuration)
      @configuration = configuration
      configuration.validate!
      uri = URI(configuration.host)
      @http_client = Net::HTTP.new(uri.host, uri.port)
      @http_client.use_ssl = uri.scheme == 'https'
    end

    def update_http_client(client)
      @http_client = client
    end
  end
end
