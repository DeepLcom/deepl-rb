# Copyright 2018 Daniel Herzog
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Resources
    class Text < Base
      attr_reader :text, :detected_source_language, :model_type_used

      def initialize(text, detected_source_language, model_type_used, *args)
        super(*args)

        @text = text
        @detected_source_language = detected_source_language
        @model_type_used = model_type_used
      end

      def to_s
        text
      end
    end
  end
end
