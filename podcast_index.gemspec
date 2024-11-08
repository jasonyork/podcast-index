require_relative "lib/podcast_index/version"

Gem::Specification.new do |spec|
  spec.name = "podcast_index"
  spec.version = PodcastIndex::VERSION
  spec.authors = ["Jason York"]

  spec.summary = "Ruby client for the podcastindex.org API"
  spec.description = "Exposes the podcastindex.org API through Ruby domain models."
  spec.homepage = "https://github.com/jasonyork/podcast-index"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jasonyork/podcast-index"
  spec.metadata["changelog_uri"] = "https://github.com/jasonyork/podcast-index/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "addressable"

  spec.add_development_dependency "codecov"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "webmock"
end
