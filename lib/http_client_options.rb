# frozen_string_literal: true

module DeepL
  class HTTPClientOptions
    attr_reader :proxy, :send_platform_info, :enable_ssl_verification, :cert_path, :open_timeout,
                :read_timeout, :write_timeout, :ssl_timeout

    def initialize(proxy, cert_path, enable_ssl_verification: true, open_timeout: nil, # rubocop:disable Metrics/ParameterLists
                   read_timeout: nil, write_timeout: nil, ssl_timeout: nil)
      @proxy = proxy
      @enable_ssl_verification = enable_ssl_verification
      @cert_path = cert_path
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @write_timeout = write_timeout
      @ssl_timeout = ssl_timeout
    end
  end
end
