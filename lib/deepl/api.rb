# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  class API
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      configuration.validate!
    end
  end
end
