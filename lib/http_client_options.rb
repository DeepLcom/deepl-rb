# frozen_string_literal: true

module DeepL
  class HTTPClientOptions
    attr_reader :proxy, :send_platform_info, :enable_ssl_verification, :cert_path

    def initialize(proxy, cert_path, enable_ssl_verification: true)
      @proxy = proxy
      @enable_ssl_verification = enable_ssl_verification
      @cert_path = cert_path
    end
  end
end
