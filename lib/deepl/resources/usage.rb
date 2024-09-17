# Copyright 2024 DeepL SE
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE.md file.
# frozen_string_literal: true

module DeepL
  module Resources
    class Usage < Base
      attr_reader :character_count, :character_limit

      def initialize(character_count, character_limit, *args)
        super(*args)

        @character_count = character_count
        @character_limit = character_limit
      end

      def to_s
        "#{character_count} / #{character_limit}"
      end

      def quota_exceeded?
        character_count >= character_limit
      end
    end
  end
end
