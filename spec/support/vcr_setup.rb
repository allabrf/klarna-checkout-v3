# frozen_string_literal: true

VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # RSpec metadata
  c.configure_rspec_metadata!
  # your HTTP request service.
  # c.hook_into :webmock
  c.hook_into :faraday
end
