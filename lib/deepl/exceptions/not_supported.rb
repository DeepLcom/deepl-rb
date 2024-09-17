# Copyright 2022 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Exceptions
    class NotSupported < Error
      def initialize(msg = 'The feature is not supported')
        super
      end
    end
  end
end
