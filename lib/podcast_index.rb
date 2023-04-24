require_relative "podcast_index/version"
require "active_support/configurable"
require "active_support/core_ext/string/inflections"
require "json"

require_relative "podcast_index/api/request"
require_relative "podcast_index/api/podcasts"
require_relative "podcast_index/api/episodes"
require_relative "podcast_index/api/search"
require_relative "podcast_index/api/recent"
require_relative "podcast_index/podcast"
require_relative "podcast_index/episode"

module PodcastIndex
  include ActiveSupport::Configurable

  config_accessor :api_key, :api_secret, :base_url

  class Error < StandardError; end

  def self.configure
    self.base_url = "https://api.podcastindex.org/api/1.0".freeze
    super
  end
end
