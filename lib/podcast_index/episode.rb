require "ostruct"
require "delegate"

module PodcastIndex
  class Episode < SimpleDelegator
    class << self

      FIND_ONE_ATTRIBUTES = %i(guid)
      FIND_MANY_ATTRIBUTES = %i(feed_id feed_url podcast_guid live itunes_id person recent)

      def find(id, fulltext: nil)
        response = Api::Episodes.by_id(id: id, fulltext: fulltext)
        from_response(response)
      end

      def find_by(attributes)
        match = (attributes.keys & FIND_ONE_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_ONE_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_ONE_ATTRIBUTES}" if match.length > 1

        send("find_by_#{match.first}", attributes[match.first])
      end

      def where(attributes)
        match = (attributes.keys & FIND_MANY_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_MANY_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_MANY_ATTRIBUTES}" if match.length > 1

        send("find_all_by_#{match.first}", **attributes)
      end

      def sample(max: nil, lang: nil, categories: [], exclude_categories: [], fulltext: nil)
        response = Api::Episodes.random(max: max, lang: lang, cat: categories.join(","),
                                        notcat: exclude_categories.join(","), fulltext: fulltext)
        from_response_collection(response, "episodes")
      end

    private

      def find_all_by_feed_id(feed_id:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_feed_id(id: feed_id, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_feed_url(feed_url:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_feed_url(url: feed_url, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_podcast_guid(podcast_guid:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_podcast_guid(podcast_guid: podcast_guid, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_by_guid(guid, feedurl: nil, feedid: nil, fulltext: nil)
        response = Api::Episodes.by_guid(guid: guid, feedurl: feedurl, feedid: feedid, fulltext: fulltext)
        from_response(response)
      end

      def find_all_by_live(live:, max: nil)
        response = Api::Episodes.live(max: max)
        from_response_collection(response)
      end

      def find_all_by_itunes_id(itunes_id:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_itunes_id(id: itunes_id, since: since, max: max, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_person(person:, fulltext: nil)
        response = Api::Search.by_person(person: person, fulltext: fulltext)
        from_response_collection(response)
      end

      def find_all_by_recent(recent:, max: nil, exclude_string: nil, before: nil, fulltext: nil)
        response = Api::Recent.episodes(max: max, exclude_string: exclude_string, before: before, fulltext: fulltext)
        from_response_collection(response)
      end

      def from_response(response)
        feed = response["episode"].transform_keys(&:underscore)
        new(JSON.parse(feed.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end

      def from_response_collection(response, collection_key = "items")
        response[collection_key].map do |item|
          episode = item.transform_keys(&:underscore)
          new(JSON.parse(episode.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
