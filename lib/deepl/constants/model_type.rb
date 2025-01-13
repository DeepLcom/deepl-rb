# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Constants
    class ModelType < BaseConstant
      QUALITY_OPTIMIZED = 'quality_optimized'
      PREFER_QUALITY_OPTIMIZED = 'prefer_quality_optimized'
      LATENCY_OPTIMIZED = 'latency_optimized'
    end
  end
end
