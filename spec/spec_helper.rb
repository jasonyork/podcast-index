require "active_support/testing/time_helpers"
require "podcast_index"
require "rspec/its"
require "webmock/rspec"
require "simplecov"

SimpleCov.start

Dir[File.join(__dir__, "support", "*.rb")].each { |file| require file }

RSpec.configure do |config|
  config.include TestFixtureHelper
  config.include ActiveSupport::Testing::TimeHelpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    PodcastIndex.configure do |c|
      c.api_key = "123"
      c.api_secret = "ABC"
    end
  end

  config.after do
    PodcastIndex.config.clear
  end
end
