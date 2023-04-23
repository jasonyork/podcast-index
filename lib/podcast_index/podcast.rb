require "ostruct"
require "delegate"

module PodcastIndex
  class Podcast < SimpleDelegator
    class << self
      def find(id)
        response = Api::Podcasts.by_feed_id(id: id)
        from_response(response)
      end

      def find_by_feed_url(url)
        response = Api::Podcasts.by_feed_url(url: url)
        from_response(response)
      end

      def find_by_guid(guid)
        response = Api::Podcasts.by_guid(guid: guid)
        from_response(response)
      end

      def find_by_itunes_id(id)
        response = Api::Podcasts.by_itunes_id(id: id)
        from_response(response)
      end

      def find_by_tag(tag)
        response = Api::Podcasts.by_tag(tag: tag)
        from_response_collection(response)
      end

      def find_by_term(term, val: nil, aponly: nil, clean: nil, fulltext: nil)
        response = Api::Search.by_term(term: term, val: val, aponly: aponly, clean: clean, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_title(title, val: nil, clean: nil, fulltext: nil)
        response = Api::Search.by_title(title: title, val: val, clean: clean, fulltext: fulltext)
        from_response_collection(response)
      end

    private

      def from_response(response)
        feed = response["feed"].transform_keys(&:underscore)
        new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end

      def from_response_collection(response)
        response["feeds"].map do |item|
          episode = item.transform_keys(&:underscore)
          new(JSON.parse(episode.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
