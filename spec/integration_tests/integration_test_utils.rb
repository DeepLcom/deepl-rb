# frozen_string_literal: true

require 'tempfile'

module IntegrationTestUtils
  EXAMPLE_TEXT = {
    'BG' => 'протонен лъч',
    'CS' => 'protonový paprsek',
    'DA' => 'protonstråle',
    'DE' => 'Protonenstrahl',
    'EL' => 'δέσμη πρωτονίων',
    'EN' => 'proton beam',
    'EN-US' => 'proton beam',
    'EN-GB' => 'proton beam',
    'ES' => 'haz de protones',
    'ET' => 'prootonikiirgus',
    'FI' => 'protonisäde',
    'FR' => 'faisceau de protons',
    'HU' => 'protonnyaláb',
    'ID' => 'berkas proton',
    'IT' => 'fascio di protoni',
    'JA' => '陽子ビーム',
    'KO' => '양성자 빔',
    'LT' => 'protonų spindulys',
    'LV' => 'protonu staru kūlis',
    'NB' => 'protonstråle',
    'NL' => 'protonenbundel',
    'PL' => 'wiązka protonów',
    'PT' => 'feixe de prótons',
    'PT-BR' => 'feixe de prótons',
    'PT-PT' => 'feixe de prótons',
    'RO' => 'fascicul de protoni',
    'RU' => 'протонный луч',
    'SK' => 'protónový lúč',
    'SL' => 'protonski žarek',
    'SV' => 'protonstråle',
    'TR' => 'proton ışını',
    'UK' => 'протонний пучок',
    'ZH' => '质子束'
  }.freeze

  def mock_server?
    ENV.key?('DEEPL_MOCK_SERVER_PORT')
  end

  def mock_proxy_server?
    ENV.key?('DEEPL_MOCK_PROXY_SERVER_PORT')
  end

  def real_server?
    !mock_server?
  end

  def setup
    @input_file = nil
    @output_file = nil
    DeepL.configure do |config|
      config.auth_key = 'your-api-token'
    end
  end

  def teardown
    unless @input_file.nil?
      @input_file.close
      @input_file.unlink
    end
    return if @output_file.nil?

    @output_file.close
    @output_file.unlink
  end

  def example_document_path(document_language)
    @input_file_name = 'example_input_document.txt' if @input_file_name.nil?
    if @input_file.nil?
      @input_file = Tempfile.new(@input_file_name)
      @input_file.write(EXAMPLE_TEXT[document_language])
      @input_file.close
    end
    @input_file.path
  end

  def example_document_translation(document_language)
    EXAMPLE_TEXT[document_language]
  end

  def output_document_path
    @output_file = Tempfile.new('example_output_document') if @output_file.nil?
    @output_file.path
  end

  # TODO: When adding E2E tests like in remaining CLs:
  # Add fixtures for mock server, etc
end

shared_context 'with temp dir' do
  around do |example|
    Dir.mktmpdir('deepl-rspec-') do |dir|
      @temp_dir = dir
      example.run
    end
  end

  attr_reader :temp_dir, :input_file_name
end

RSpec.configure do |c|
  c.include IntegrationTestUtils
end
