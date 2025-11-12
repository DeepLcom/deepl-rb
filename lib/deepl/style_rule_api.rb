# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  class StyleRuleApi
    def initialize(api, options = {})
      @api = api
      @options = options
    end

    def list(options = {})
      DeepL::Requests::StyleRule::List.new(@api, options).request
    end
  end
end
