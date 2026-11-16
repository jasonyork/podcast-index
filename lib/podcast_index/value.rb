require "ostruct"
require "delegate"

module PodcastIndex
  class Value < SimpleDelegator
    class << self
      FIND_ONE_ATTRIBUTES = %i[feed_id feed_url podcast_guid].freeze

      def find_by(attributes)
        return find_by_episode_guid(**attributes.slice(:podcast_guid, :episode_guid)) if attributes.key?(:episode_guid)

        match = (attributes.keys & FIND_ONE_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_ONE_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_ONE_ATTRIBUTES}" if match.length > 1

        send("find_by_#{match.first}", attributes[match.first])
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::ValueNotFound, e.message
      end

    private

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

        value = response["value"].transform_keys(&:underscore)
        new(JSON.parse(value.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end
    end
  end
end
