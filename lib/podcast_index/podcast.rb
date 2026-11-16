require "delegate"

# rubocop:disable Metrics/ParameterLists, Lint/UnusedMethodArgument
module PodcastIndex
  class Podcast < SimpleDelegator
    extend Model

    class << self
      FIND_ONE_ATTRIBUTES = %i[feed_url guid itunes_id].freeze
      FIND_MANY_ATTRIBUTES = %i[guids tag medium term title trending dead recent new new_value newly_found].freeze

      def find(id)
        response = Api::Podcasts.by_feed_id(id: id)
        from_response(response)
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::PodcastNotFound, e.message
      end

      def find_by(attributes)
        key = lookup_attribute(attributes, FIND_ONE_ATTRIBUTES)
        send("find_by_#{key}", attributes[key])
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::PodcastNotFound, e.message
      end

      def where(attributes)
        return find_all_music_by_term(**attributes) if attributes[:medium] == "music" && attributes[:term].present?

        key = lookup_attribute(attributes, FIND_MANY_ATTRIBUTES)
        send("find_all_by_#{key}", **attributes)
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

      def find_all_by_guids(guids:)
        response = Api::Podcasts.batch_by_guid(guids: guids)
        build_all(response["feeds"])
      end

      def find_all_by_tag(tag:, max: nil, start_at: nil)
        response = Api::Podcasts.by_tag(tag: tag, max: max, start_at: start_at)
        build_all(response["feeds"])
      end

      def find_all_music_by_term(medium:, term:, val: nil, aponly: nil, clean: nil, fulltext: nil, max: nil)
        response = Api::Search.music_by_term(term: term, val: val, aponly: aponly, clean: clean, fulltext: fulltext,
                                             max: max)
        build_all(response["feeds"])
      end

      def find_all_by_medium(medium:, max: nil)
        response = Api::Podcasts.by_medium(medium: medium, max: max)
        build_all(response["feeds"])
      end

      def find_all_by_trending(trending:, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
        response = Api::Podcasts.trending(max: max, since: since, lang: lang, cat: categories.join(","),
                                          notcat: exclude_categories.join(","))
        build_all(response["feeds"])
      end

      def find_all_by_dead(*)
        response = Api::Podcasts.dead
        build_all(response["feeds"])
      end

      def find_all_by_term(term:, val: nil, aponly: nil, clean: nil, fulltext: nil, similar: nil, max: nil)
        response = Api::Search.by_term(term: term, val: val, aponly: aponly, clean: clean, fulltext: fulltext,
                                       similar: similar, max: max)
        build_all(response["feeds"])
      end

      def find_all_by_title(title:, val: nil, clean: nil, fulltext: nil, similar: nil, max: nil)
        response = Api::Search.by_title(title: title, val: val, clean: clean, fulltext: fulltext, similar: similar,
                                        max: max)
        build_all(response["feeds"])
      end

      def find_all_by_recent(recent:, max: nil, since: nil, lang: nil, categories: [], exclude_categories: [])
        response = Api::Recent.feeds(max: max, since: since, lang: lang, cat: categories.join(","),
                                     notcat: exclude_categories.join(","))
        build_all(response["feeds"])
      end

      def find_all_by_new(new:, max: nil, since: nil, feedid: nil, desc: nil)
        response = Api::Recent.new_feeds(max: max, since: since, feedid: feedid, desc: desc)
        build_all(response["feeds"])
      end

      def find_all_by_new_value(new_value:, max: nil, since: nil)
        response = Api::Recent.new_value_feeds(max: max, since: since)
        build_all(response["feeds"])
      end

      def find_all_by_newly_found(newly_found:, max: nil, since: nil)
        response = Api::Recent.data(max: max, since: since)
        # This one has a bit of an oddball response.  It's nested in a "data" attribute and all the keys
        # for each feed are prefixed with "feed" (see example fixture)
        build_all(response["data"]["feeds"].map { |item| item.transform_keys { |key| key.delete_prefix("feed") } })
      end

      def from_response(response)
        raise PodcastIndex::PodcastNotFound, response["description"] if response["feed"].blank?

        build(response["feed"])
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists, Lint/UnusedMethodArgument
