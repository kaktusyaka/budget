VCR.configure do |config|
  config.cassette_library_dir  = Rails.root.join('spec', 'vcr_cassettes')
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
