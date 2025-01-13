# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Constants
    class SplitSentences < BaseConstant
      NO_SPLITTING = '0'
      SPLIT_ON_PUNCTUATION_AND_NEWLINES = '1'
      SPLIT_ON_PUNCTUATION_ONLY = 'nonewlines'
    end
  end
end
