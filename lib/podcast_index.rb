require_relative "podcast_index/version"
require "active_support/ordered_options"
require "active_support/core_ext/string/inflections"
require "json"

require_relative "podcast_index/api/request"

require_relative "podcast_index/api/categories"
require_relative "podcast_index/api/episodes"
require_relative "podcast_index/api/podcasts"
require_relative "podcast_index/api/recent"
require_relative "podcast_index/api/search"
require_relative "podcast_index/api/stats"
require_relative "podcast_index/api/value"
require_relative "podcast_index/category"
require_relative "podcast_index/episode"
require_relative "podcast_index/podcast"
require_relative "podcast_index/soundbite"
require_relative "podcast_index/stats"
require_relative "podcast_index/value"

module PodcastIndex
  class Error < StandardError; end
  class PodcastNotFound < Error; end
  class CategoryNotFound < Error; end

  def self.configure
    config.base_url = "https://api.podcastindex.org/api/1.0".freeze
    yield config
  end

  def self.config
    @config ||= ActiveSupport::OrderedOptions.new
  end

  def self.api_key = config.api_key
  def self.api_secret = config.api_secret
  def self.base_url = config.base_url
end
