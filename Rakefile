require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Run specs against the live podcastindex.org API (needs API_KEY and API_SECRET, e.g. in .env)"
  RSpec::Core::RakeTask.new(:live) do |t|
    ENV["LIVE_API"] = "1"
    t.rspec_opts = "--tag live"
  end
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]
