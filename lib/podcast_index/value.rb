require "delegate"

module PodcastIndex
  class Value < SimpleDelegator
    extend Model

    class << self
      FIND_ONE_ATTRIBUTES = %i[feed_id feed_url podcast_guid].freeze
      FIND_MANY_ATTRIBUTES = %i[episode_guids].freeze

      def find_by(attributes)
        return find_by_episode_guid(**attributes.slice(:podcast_guid, :episode_guid)) if attributes.key?(:episode_guid)

        key = lookup_attribute(attributes, FIND_ONE_ATTRIBUTES)
        send("find_by_#{key}", attributes[key])
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::ValueNotFound, e.message
      end

      def where(attributes)
        key = lookup_attribute(attributes, FIND_MANY_ATTRIBUTES)
        send("find_all_by_#{key}", **attributes)
      end

    private

      # episode_guids: a hash of podcast guid => array of episode guids
      def find_all_by_episode_guids(episode_guids:)
        response = Api::Value.batch_by_episode_guid(guids: episode_guids)
        # Each item wraps its value block with the episode's details; flatten them into one object. The API omits
        # "value" when nothing matches.
        build_all(Array(response["value"]).map { |item| item.except("value").merge(item["value"]) })
      end

      def find_by_feed_id(feed_id)
        response = Api::Value.by_feed_id(id: feed_id)
        from_response(response)
      end

      def find_by_feed_url(feed_url)
        response = Api::Value.by_feed_url(url: feed_url)
        from_response(response)
      end

      def find_by_podcast_guid(podcast_guid)
        response = Api::Value.by_podcast_guid(guid: podcast_guid)
        from_response(response)
      end

      def find_by_episode_guid(episode_guid:, podcast_guid: nil)
        raise ArgumentError, "episode_guid must be supplied with podcast_guid" if podcast_guid.blank?

        response = Api::Value.by_episode_guid(podcast_guid: podcast_guid, episode_guid: episode_guid)
        from_response(response)
      end

      def from_response(response)
        raise PodcastIndex::ValueNotFound, response["description"] if response["value"].blank?

        build(response["value"])
      end
    end
  end
end
