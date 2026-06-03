# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

module ManagedStyleRule
  def with_managed_style_rule(name:, language:, options: {})
    style_rule = DeepL.style_rules.create(name, language, options)
    yield style_rule
  ensure
    begin
      DeepL.style_rules.destroy(style_rule.style_id) if style_rule
    rescue StandardError
      nil
    end
  end
end
