# frozen_string_literal: true

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec/cassettes')
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<AWS_ACCESS_KEY>') { ENV['AWS_ACCESS_KEY'] }
  c.filter_sensitive_data('<AWS_S3_BUCKET>') { ENV['AWS_S3_BUCKET'] }
  c.allow_http_connections_when_no_cassette = true

  %w[recordable stubbed].each do |method|
    c.after_http_request("#{method}?".to_sym) do |request, _response|
      puts "- VCR - #{method} - [#{request.method}] #{request.parsed_uri}"
      if request.externally_stubbed?
        puts '  stubbed by WebMock'
      else
        puts "  used cassette - #{VCR.current_cassette.try(:file)}"
      end
    end
  end
end
