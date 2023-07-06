require "ostruct"
require "delegate"

# rubocop:disable Metrics/ParameterLists, Lint/UnusedMethodArgument
module PodcastIndex
  class Podcast < SimpleDelegator
    class << self
      FIND_ONE_ATTRIBUTES = %i[feed_url guid itunes_id].freeze
      FIND_MANY_ATTRIBUTES = %i[tag medium term title trending dead recent new newly_found].freeze

      def find(id)
        response = Api::Podcasts.by_feed_id(id: id)
        raise PodcastIndex::PodcastNotFound, response["description"] if response["feed"].empty?

        from_response(response)
      end

      def find_by(attributes)
        match = (attributes.keys & FIND_ONE_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_ONE_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_ONE_ATTRIBUTES}" if match.length > 1

        send("find_by_#{match.first}", attributes[match.first])
      end

      def where(attributes)
        return find_all_music_by_term(**attributes) if attributes[:medium] == "music" && attributes[:term].present?

        match = (attributes.keys & FIND_MANY_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_MANY_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_MANY_ATTRIBUTES}" if match.length > 1

        send("find_all_by_#{match.first}", **attributes)
      end

    private

      def find_by_feed_url(feed_url)
        response = Api::Podcasts.by_feed_url(url: feed_url)
        from_response(response)
      end

      def find_by_guid(guid)
        response = Api::Podcasts.by_guid(guid: guid)
        from_response(response)
      end

      def find_by_itunes_id(itunes_id)
        response = Api::Podcasts.by_itunes_id(id: itunes_id)
        from_response(response)
      end

      def find_all_by_tag(tag:)
        response = Api::Podcasts.by_tag(tag: tag)
        from_response_collection(response)
      end

      def find_all_music_by_term(medium:, term:, val: nil, aponly: nil, clean: nil, fulltext: nil)
        response = Api::Search.music_by_term(term: term, val: val, aponly: aponly, clean: clean, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_medium(medium:)
        response = Api::Podcasts.by_medium(medium: medium)
        from_response_collection(response)
      end

      def find_all_by_trending(trending:, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
        response = Api::Podcasts.trending(max: max, since: since, lang: lang, cat: categories.join(","),
                                          notcat: exclude_categories.join(","))
        from_response_collection(response)
      end

      def find_all_by_dead(*)
        response = Api::Podcasts.dead
        from_response_collection(response)
      end

      def find_all_by_term(term:, val: nil, aponly: nil, clean: nil, fulltext: nil)
        response = Api::Search.by_term(term: term, val: val, aponly: aponly, clean: clean, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_title(title:, val: nil, clean: nil, fulltext: nil)
        response = Api::Search.by_title(title: title, val: val, clean: clean, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_recent(recent:, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
        response = Api::Recent.feeds(max: max, since: since, lang: lang, cat: categories.join(","),
                                     notcat: exclude_categories.join(","))
        from_response_collection(response)
      end

      def find_all_by_new(new:, max: nil, since: nil, feedid: nil, desc: nil)
        response = Api::Recent.new_feeds(max: max, since: since, feedid: feedid, desc: desc)
        from_response_collection(response)
      end

      def find_all_by_newly_found(newly_found:, max: nil, since: nil)
        response = Api::Recent.data(max: max, since: since)
        # This one has a bit of an oddball response.  It's nested in a "data" attribute and all the keys
        # for each feed are prefixed with "feed" (see example fixture)
        response["data"]["feeds"].map do |item|
          feed = item.transform_keys { |key| key.delete_prefix("feed").underscore }
          new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end

      def from_response(response)
        feed = response["feed"].transform_keys(&:underscore)
        new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end

      def from_response_collection(response)
        response["feeds"].map do |item|
          feed = item.transform_keys(&:underscore)
          new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists, Lint/UnusedMethodArgument
