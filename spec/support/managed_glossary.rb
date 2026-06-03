# Copyright 2025 DeepL SE (https://www.deepl.com)
# Use of this source code is governed by an MIT
# license that can be found in the LICENSE file.
# frozen_string_literal: true

module ManagedGlossary
  def with_managed_glossary(name:, source_lang:, target_lang:, entries:, options: {})
    glossary = DeepL.glossaries.create(name, source_lang, target_lang, entries, options)
    yield glossary
  ensure
    begin
      DeepL.glossaries.destroy(glossary.id) if glossary
    rescue StandardError
      nil
    end
  end
end
