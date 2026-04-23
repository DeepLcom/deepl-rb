# Copyright 2026 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  class TranslationMemoryApi
    def initialize(api, options = {})
      @api = api
      @options = options
    end

    def list(options = {})
      DeepL::Requests::TranslationMemory::List.new(@api, options).request
    end
  end
end
