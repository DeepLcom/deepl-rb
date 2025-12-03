[![Gem Version](https://badge.fury.io/rb/deepl-rb.svg)](https://badge.fury.io/rb/deepl-rb)

# DeepL Ruby Library

The [DeepL API](https://developers.deepl.com/docs/api-reference/translate) is a language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations. This opens a whole universe of opportunities for developers: any translation product you can imagine can now be built on top of DeepL's best-in-class translation technology.

The DeepL Ruby library offers a convenient way for applications written in Ruby to interact with the DeepL API. We intend to support all API functions with the library, though support for new features may be added to the library after they’re added to the API.

## Getting an authentication key

To use the DeepL Ruby Library, you'll need an API authentication key. To get a key, [please create an account here](https://www.deepl.com/pro?utm_source=github&utm_medium=github-ruby-readme#developer). With a DeepL API Free account you can translate up to 500,000 characters/month for free.

## Installation

Install this gem with

```sh
gem install deepl-rb
# Load it in your ruby file using `require 'deepl'`
```

Or add it to your Gemfile:

```rb
gem 'deepl-rb', require: 'deepl'
```

## Usage

Setup an environment variable named `DEEPL_AUTH_KEY` with your authentication key:

```sh
export DEEPL_AUTH_KEY="your-api-token"
```

Alternatively, you can configure the API client within a ruby block:

```rb
DeepL.configure do |config|
  config.auth_key = 'your-api-token'
end
```

You can also configure the API host and the API version:

```rb
DeepL.configure do |config|
  config.auth_key = 'your-api-token'
  config.host = 'https://api-free.deepl.com' # Default value is 'https://api.deepl.com'
  config.version = 'v1' # Default value is 'v2'
end
```

### Available languages

Available languages can be retrieved via API:

```rb
languages = DeepL.languages

puts languages.class
# => Array
puts languages.first.class
# => DeepL::Resources::Language
puts "#{languages.first.code} -> #{languages.first.name}"
# => "ES -> Spanish"
```

Note that source and target languages may be different, which can be retrieved by using the `type`
option:

```rb
puts DeepL.languages(type: :source).count
# => 24
puts DeepL.languages(type: :target).count
# => 26
```

All languages are also defined on the
[official API documentation](https://developers.deepl.com/docs/api-reference/translate).

Note that target languages may include the `supports_formality` flag, which may be checked
using the `DeepL::Resources::Language#supports_formality?`.

### Translate

To translate a simple text, use the `translate` method:

```rb
translation = DeepL.translate 'This is my text', 'EN', 'ES'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => 'Este es mi texto'
```

Enable auto-detect source language by skipping the source language with `nil`:

```rb
translation = DeepL.translate 'This is my text', nil, 'ES'

puts translation.detected_source_language
# => 'EN'
```

Translate a list of texts by passing an array as an argument:

```rb
texts = ['Sample text', 'Another text']
translations = DeepL.translate texts, 'EN', 'ES'

puts translations.class
# => Array
puts translations.first.class
# => DeepL::Resources::Text
```

You can also use custom query parameters, like `tag_handling`, `split_sentences`, `non_splitting_tags` or `ignore_tags`:

```rb
translation = DeepL.translate '<p>A sample</p>', 'EN', 'ES',
                              tag_handling: 'xml', split_sentences: false,
                              non_splitting_tags: 'h1', ignore_tags: %w[code pre]

puts translation.text
# => "<p>Una muestra</p>"
```

To translate with context, simply supply the `context` parameter:

```rb
translation = DeepL.translate 'That is hot!', 'EN', 'ES',
                              context: 'He did not like the jalapenos in his meal.'

puts translation.text
# => "¡Eso es picante!"
```

To specify a type of translation model to use, you can use the `model_type` option:

```rb
translation = DeepL.translate 'That is hot!', 'EN', 'DE',
                              model_type: 'quality_optimized'
```

This would use next-gen translation models for the translation. The available values are

- `'quality_optimized'`: use a translation model that maximizes translation quality, at the
  cost of response time. This option may be unavailable for some language pairs.
- `'prefer_quality_optimized'`: use the highest-quality translation model for the given
  language pair.
- `'latency_optimized'`: use a translation model that minimizes response time, at the cost
  of translation quality.

To translate with custom instructions, supply the `custom_instructions` parameter:

```rb
translation = DeepL.translate 'Hello, world!', 'EN', 'DE',
                              custom_instructions: ['Use informal language', 'Be concise']

puts translation.text
```

Up to 10 custom instructions can be specified, each with a maximum of 300 characters.
The target language must be `de`, `en`, `es`, `fr`, `it`, `ja`, `ko`, `zh` or any variants.
Note that using `custom_instructions` will automatically use `quality_optimized` models,
and cannot be combined with `model_type: 'latency_optimized'`.

The following parameters will be automatically converted:

| Parameter             | Conversion
| --------------------- | ---------------
| `preserve_formatting` | Converts `false` to `'0'` and `true` to `'1'`
| `split_sentences`     | Converts `false` to `'0'` and `true` to `'1'`
| `outline_detection`   | Converts `false` to `'0'` and `true` to `'1'`
| `splitting_tags`      | Converts arrays to strings joining by commas
| `non_splitting_tags`  | Converts arrays to strings joining by commas
| `ignore_tags`         | Converts arrays to strings joining by commas
| `formality`           | No conversion applied
| `glossary_id`         | No conversion applied
| `style_id`            | No conversion applied
| `style_rule`          | No conversion applied (can be a string ID or a StyleRule object)
| `context`             | No conversion applied
| `custom_instructions` | No conversion applied
| `extra_body_parameters` | Hash of extra parameters to pass in the body of the HTTP request. Can be used to access beta features, or to override built-in parameters for testing purposes. Extra parameters can override keys explicitly set by the client.

### Rephrase Text

To rephrase or improve text, including changing the writing style or tone of the text, use the `rephrase` method:

```rb
rephrased_text = DeepL.rephrase 'you will acquire new rephrased text', 'EN'

puts rephrased_text.class
# => DeepL::Resources::Text
puts rephrased_text.text
# => 'You get new rephrased text.'
```

As with translate, the text input can be a single string or an array of strings.

You can use the additional arguments to specify the writing style or tone you want for the rephrased text:

```rb
rephrased_text = DeepL.rephrase 'you will acquire new rephrased text', 'EN', 'casual'

puts rephrased_text.text
# => 'You'll get new, rephrased text.'
```

```rb
rephrased_text = DeepL.rephrase 'you will acquire new rephrased text', 'EN', nil, 'friendly'

puts rephrased_text.text
# => 'You'll get to enjoy new, rephrased text!'
```

### Glossaries

To create a glossary, use the `glossaries.create` method. The glossary `entries` argument should be an array of text pairs. Each pair includes the source and the target translations.

```rb
entries = [
  ['Hello World', 'Hola Tierra'],
  ['car', 'auto']
]
glossary = DeepL.glossaries.create 'Mi Glosario', 'EN', 'ES', entries

puts glossary.class
# => DeepL::Resources::Glossary
puts glossary.id
# => 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'
puts glossary.entry_count
# => 2
```

Created glossaries can be used in the `translate` method by specifying the `glossary_id` option:

```rb
translation = DeepL.translate 'Hello World', 'EN', 'ES', glossary_id: 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => 'Hola Tierra'

translation = DeepL.translate "I wish we had a car.", 'EN', 'ES', glossary_id: 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => Ojalá tuviéramos un auto.
```

To list all the glossaries available, use the `glossaries.list` method:

```rb
glossaries = DeepL.glossaries.list

puts glossaries.class
# => Array
puts glossaries.first.class
# => DeepL::Resources::Glossary
```

To find an existing glossary, use the `glossaries.find` method:

```rb
glossary = DeepL.glossaries.find 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts glossary.class
# => DeepL::Resources::Glossary
```

The glossary resource does not include the glossary entries. To list the glossary entries, use the `glossaries.entries` method:

```rb
entries = DeepL.glossaries.entries 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts entries.class
# => Array
puts entries.size
# => 2
pp entries.first
# => ["Hello World", "Hola Tierra"]
```

To delete an existing glossary, use the `glossaries.destroy` method:

```rb
glossary_id = DeepL.glossaries.destroy 'aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e'

puts glossary_id
# => aa48c7f0-0d02-413e-8a06-d5bbf0ca7a6e
```

You can list all the language pairs supported by glossaries using the `glossaries.language_pairs` method:

```rb
language_pairs = DeepL.glossaries.language_pairs

puts language_pairs.class
# => Array
puts language_pairs.first.class
# => DeepL::Resources::LanguagePair
puts language_pairs.first.source_lang
# => en
puts language_pairs.first.target_lang
# => de
```

### Style Rules

Style rules allow you to customize your translations using a managed, shared list
of rules for style, formatting, and more. Multiple style rules can be stored with
your account, each with a user-specified name and a uniquely-assigned ID.

#### Creating and managing style rules

Currently style rules must be created and managed in the DeepL UI via
https://www.deepl.com/en/custom-rules. Full CRUD functionality via the APIs will
come shortly.

#### Listing all style rules

`style_rules.list` returns a list of `StyleRule` objects
corresponding to all of your stored style rules. The method accepts optional
parameters: `page` (page number for pagination, 0-indexed), `page_size` (number
of items per page), and `detailed` (whether to include detailed configuration
rules in the `configured_rules` property).

```rb
# Get all style rules
style_rules = DeepL.style_rules.list
style_rules.each do |rule|
  puts "#{rule.name} (#{rule.style_id})"
end

# Get style rules with detailed configuration
style_rules = DeepL.style_rules.list(detailed: true)
style_rules.each do |rule|
  if rule.configured_rules
    puts "  Number formatting: #{rule.configured_rules.numbers.keys.join(', ')}"
  end
end
```

Created style rules can be used in the `translate` method by specifying the `style_id` option:

```rb
translation = DeepL.translate 'Hello World', 'EN', 'ES', style_id: 'dca2e053-8ae5-45e6-a0d2-881156e7f4e4'

puts translation.class
# => DeepL::Resources::Text
puts translation.text
# => 'Hola Mundo'
```

You can also pass a `StyleRule` object directly:

```rb
style_rules = DeepL.style_rules.list
style_rule = style_rules.first

translation = DeepL.translate 'Hello World', 'EN', 'ES', style_rule: style_rule
```

### Monitor usage

To check current API usage, use:

```rb
usage = DeepL.usage

puts usage.character_count
# => 180118
puts usage.character_limit
# => 1250000
```

### Translate documents

To translate a document, use the `document.translate_document` method. Example:

```rb
DeepL.document.translate_document('/path/to/spanish_document.pdf', '/path/to/translated_document.pdf', 'ES', 'EN')
```

The lower level `upload`, `get_status` and `download` methods are also exposed, as well as the convenience method `wait_until_document_translation_finished` on the `DocumentHandle` object, which would replace `get_status`:
```rb
doc_handle = DeepL.document.upload('/path/to/spanish_document.pdf', 'ES', 'EN')
doc_status = doc_handle.wait_until_document_translation_finished # alternatively poll `DeepL.document.get_status`
# until the `doc_status.successful?`
DeepL.document.download(doc_handle, '/path/to/translated_document.pdf') unless doc_status.error?
```

You can also pass additional options to document translation methods, including `extra_body_parameters`:

```rb
options = {
  formality: 'more',
  extra_body_parameters: { example_param: 'true' }
}
doc_handle = DeepL.document.upload('/path/to/spanish_document.pdf', 'ES', 'EN', nil, options)
```

The `extra_body_parameters` option allows you to pass arbitrary parameters in the request body. This can be used to access beta features by adding new parameters, or to override built-in parameters (such as `target_lang`, `source_lang`, etc.) for testing purposes.

### Handle exceptions

You can capture and process exceptions that may be raised during API calls. These are all the possible exceptions:

| Exception class | Description |
| --------------- | ----------- |
| `DeepL::Exceptions::AuthorizationFailed` | The authorization process has failed. Check your `auth_key` value. |
| `DeepL::Exceptions::BadRequest` | Something is wrong in your request. Check `exception.message` for more information. |
| `DeepL::Exceptions::DocumentTranslationError` | An error occured during document translation. Check `exception.message` for more information. |
| `DeepL::Exceptions::LimitExceeded` | You've reached the API's call limit. |
| `DeepL::Exceptions::QuotaExceeded` | You've reached the API's character limit. |
| `DeepL::Exceptions::RequestError` | An unkown request error. Check `exception.response` and `exception.request` for more information. |
| `DeepL::Exceptions::NotSupported` | The requested method or API endpoint is not supported. |
| `DeepL::Exceptions::RequestEntityTooLarge` | Your request is too large, reduce the amount of data you are sending. The API has a request size limit of 128 KiB. |
| `DeepL::Exceptions::ServerError` | An error occured in the DeepL API, wait a short amount of time and retry. |

An exampling of handling a generic exception:

```rb
def my_method
  item = DeepL.translate 'This is my text', nil, 'ES'
rescue DeepL::Exceptions::RequestError => e
  puts 'Oops!'
  puts "Code: #{e.response.code}"
  puts "Response body: #{e.response.body}"
  puts "Request body: #{e.request.body}"
end
```

### Logging

To enable logging, pass a suitable logging object (e.g. the default `Logger` from the Ruby standard library) when configuring the library. The library logs HTTP requests to `INFO` and debug information to `DEBUG`. Example:

```rb
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

deepl.configure do |config|
  config.auth_key = configuration.auth_key
  config.logger = logger
end
```

### Proxy configuration

To use HTTP proxies, a session needs to be used. The proxy can then be configured as part of the HTTP client options:

```rb
client_options = HTTPClientOptions.new({ 'proxy_addr' => 'http://localhost', 'proxy_port' => 80 })
deepl.with_session(client_options) do |session|
  # ...
end
```

### Anonymous platform information

By default, we send some basic information about the platform the client library is running on with each request, see [here for an explanation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent). This data is completely anonymous and only used to improve our product, not track any individual users. If you do not wish to send this data, you can opt-out by setting the `send_platform_info` flag in the configuration to `false` like so:

```rb
deepl.configure({}, nil, nil, false) do |config|
  # ...
end
```

You can also complete customize the `User-Agent` header like so:

```rb
deepl.configure do |config|
  config.user_agent = 'myCustomUserAgent'
end
```

### Sending multiple requests

When writing an application that send multiple requests, using a HTTP session will give better performance through [HTTP Keep-Alive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Keep-Alive). You can use it by simply wrapping your requests in a `with_session` block:

```rb
deepl.with_session do |session|
  deepl.translate(sentence1, 'DE', 'EN-GB')
  deepl.translate(sentence2, 'DE', 'EN-GB')
  deepl.translate(sentence3, 'DE', 'EN-GB')
end
```

### Writing a plugin

If you use this library in an application, please identify the application by setting the name and version of the plugin:

```rb
deepl.configure({}, 'MyTranslationPlugin', '1.0.1') do |config|
  # ...
end
```

This information is passed along when the library makes calls to the DeepL API. Both name and version are required. Please note that setting the `User-Agent` header via `deepl.configure` will override this setting, if you need to use this, please manually identify your Application in the `User-Agent` header.

## Options Constants

The available values for various possible options are provided under the `DeepL::Constants` namespace. The currently available options are

`TagHandling`
`SplitSentences`
`ModelType`
`Formality`
`WritingStyle`
`Tone`

To view all the possible options for a given constant, call `options`:

```rb
all_available_tones = DeepL::Constants::Tones.options
```

To check if a given string is a possible option for a given constant, call `valid?`:

```rb
DeepL::Constants::Tones.valid?('friendly') # true
DeepL::Constants::Tones.valid?('rude') # false
```

## Integrations

### Ruby on Rails

You may use this gem as a standalone service by creating an initializer on your
`config/initializers` folder with your DeepL configuration. For example:

```rb
# config/initializers/deepl.rb
DeepL.configure do |config|
  # Your configuration goes here
end
```

Since the DeepL service is defined globally, you can use service anywhere in your code
(controllers, models, views, jobs, plain ruby objects… you name it).

### i18n-tasks

You may also take a look at [`i18n-tasks`](https://github.com/glebm/i18n-tasks), which is a gem
that helps you find and manage missing and unused translations. `deepl-rb` is used as one of the
backend services to translate content.

## Development

Clone the repository, and install its dependencies:

```sh
git clone https://github.com/DeepLcom/deepl-rb
cd deepl-rb
bundle install
```

To run tests (rspec and rubocop), use

```
bundle exec rake test
```

### Caution: Changing VCR Tests

If you need to rerecord some of the VCR tests, simply setting `record: :new_episodes` and rerunning `rspec` won't be enough in some cases, specifically around document translation (due to its statefulness) and glossaries (since a glossary ID is associated with a specific API account).
For example, there are document translations tests that split up the `upload`, `get_status` and `download` calls into separate test cases. You need to first rerecord the `upload` call, you can do execute a single test like this (the line should be where the `it` block of the test starts):

```sh
rspec ./spec/api/deepl_spec.rb:152
```

This will return a `document_id` and a `document_key`, you will need to update the values in the `get_status` and `download` tests accordingly. You can find examples for this in the git history.
Similarly, for the glossary tests you will need to delete the recorded HTTP requests for certain glossary IDs so that `rspec` will create the glossaries on your account instead. Feel free to reach out on our discord if you run into any trouble here.

## Acknowledgements

This library was originally developed by [Daniel Herzog](mailto:info@danielherzog.es), we are grateful for his contributions. Beginning with v3.0.0, DeepL took over development and officially supports and maintains the library together with Daniel.