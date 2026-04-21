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

    def create(name, language, options = {})
      DeepL::Requests::StyleRule::Create.new(@api, name, language, options).request
    end

    def find(style_id, options = {})
      DeepL::Requests::StyleRule::Find.new(@api, style_id, options).request
    end

    def update_name(style_id, name, options = {})
      DeepL::Requests::StyleRule::Update.new(@api, style_id, name, options).request
    end

    def destroy(style_id, options = {})
      DeepL::Requests::StyleRule::Destroy.new(@api, style_id, options).request
    end

    def update_configured_rules(style_id, configured_rules, options = {})
      DeepL::Requests::StyleRule::UpdateConfiguredRules.new(@api, style_id, configured_rules,
                                                            options).request
    end

    def create_custom_instruction(style_id, label, prompt, source_language = nil, options = {})
      DeepL::Requests::StyleRule::CreateCustomInstruction.new(@api, style_id, label, prompt,
                                                              source_language, options).request
    end

    def find_custom_instruction(style_id, instruction_id, options = {})
      DeepL::Requests::StyleRule::FindCustomInstruction.new(@api, style_id, instruction_id,
                                                            options).request
    end

    def update_custom_instruction(style_id, instruction_id, label,
                                  prompt, source_language = nil,
                                  options = {})
      DeepL::Requests::StyleRule::UpdateCustomInstruction.new(@api, style_id, instruction_id,
                                                              label, prompt, source_language,
                                                              options).request
    end

    def destroy_custom_instruction(style_id, instruction_id, options = {})
      DeepL::Requests::StyleRule::DestroyCustomInstruction.new(@api, style_id, instruction_id,
                                                               options).request
    end
  end
end
