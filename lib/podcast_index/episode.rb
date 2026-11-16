require "delegate"

# rubocop:disable Metrics/ParameterLists
module PodcastIndex
  class Episode < SimpleDelegator
    extend Model

    class << self
      FIND_ONE_ATTRIBUTES = %i[guid].freeze
      FIND_MANY_ATTRIBUTES = %i[feed_id feed_url podcast_guid live itunes_id person recent].freeze

      def find(id, fulltext: nil)
        response = Api::Episodes.by_id(id: id, fulltext: fulltext)
        from_response(response)
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::EpisodeNotFound, e.message
      end

      def find_by(attributes)
        key = lookup_attribute(attributes, FIND_ONE_ATTRIBUTES)
        send("find_by_#{key}", attributes[key], **attributes.except(key))
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::EpisodeNotFound, e.message
      end

      def where(attributes)
        key = lookup_attribute(attributes, FIND_MANY_ATTRIBUTES)
        send("find_all_by_#{key}", **attributes)
      end

      def sample(max: nil, lang: nil, categories: [], exclude_categories: [], fulltext: nil)
        response = Api::Episodes.random(max: max, lang: lang, cat: categories.join(","),
                                        notcat: exclude_categories.join(","), fulltext: fulltext)
        build_all(response["episodes"])
      end

    private

      def find_all_by_feed_id(feed_id:, since: nil, max: nil, fulltext: nil, enclosure: nil, newest: nil)
        response = Api::Episodes.by_feed_id(id: feed_id, since: since, max: max, fulltext: fulltext,
                                            enclosure: enclosure, newest: newest)
        build_all(response["items"])
      end

      def find_all_by_feed_url(feed_url:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_feed_url(url: feed_url, since: since, max: max, fulltext: fulltext)
        build_all(response["items"])
      end

      def find_all_by_podcast_guid(podcast_guid:, since: nil, max: nil, fulltext: nil)
        response = Api::Episodes.by_podcast_guid(podcast_guid: podcast_guid, since: since, max: max, fulltext: fulltext)
        build_all(response["items"])
      end

      def find_by_guid(guid, feedurl: nil, feedid: nil, podcastguid: nil, fulltext: nil)
        response = Api::Episodes.by_guid(guid: guid, feedurl: feedurl, feedid: feedid, podcastguid: podcastguid,
                                         fulltext: fulltext)
        from_response(response)
      end

      def find_all_by_live(live:, max: nil) # rubocop:disable Lint/UnusedMethodArgument
        response = Api::Episodes.live(max: max)
        build_all(response["items"])
      end

      def find_all_by_itunes_id(itunes_id:, since: nil, max: nil, fulltext: nil, enclosure: nil)
        response = Api::Episodes.by_itunes_id(id: itunes_id, since: since, max: max, fulltext: fulltext,
                                              enclosure: enclosure)
        build_all(response["items"])
      end

      def find_all_by_person(person:, fulltext: nil, max: nil)
        response = Api::Search.by_person(person: person, fulltext: fulltext, max: max)
        build_all(response["items"])
      end

      def find_all_by_recent(recent:, max: nil, exclude_string: nil, before: nil, fulltext: nil) # rubocop:disable Lint/UnusedMethodArgument
        response = Api::Recent.episodes(max: max, exclude_string: exclude_string, before: before, fulltext: fulltext)
        build_all(response["items"])
      end

      def from_response(response)
        raise PodcastIndex::EpisodeNotFound, response["description"] if response["episode"].blank?

        build(response["episode"])
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
