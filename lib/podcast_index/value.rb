require "ostruct"
require "delegate"

module PodcastIndex
  class Value < SimpleDelegator
    class << self
      FIND_ONE_ATTRIBUTES = %i[feed_id feed_url podcast_guid].freeze
      FIND_MANY_ATTRIBUTES = %i[episode_guids].freeze

      def find_by(attributes)
        return find_by_episode_guid(**attributes.slice(:podcast_guid, :episode_guid)) if attributes.key?(:episode_guid)

        match = (attributes.keys & FIND_ONE_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_ONE_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_ONE_ATTRIBUTES}" if match.length > 1

        send("find_by_#{match.first}", attributes[match.first])
      rescue PodcastIndex::RecordNotFound => e
        raise PodcastIndex::ValueNotFound, e.message
      end

      def where(attributes)
        match = (attributes.keys & FIND_MANY_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_MANY_ATTRIBUTES}" unless match.present?

        send("find_all_by_#{match.first}", **attributes)
      end

    private

      # episode_guids: a hash of podcast guid => array of episode guids
      def find_all_by_episode_guids(episode_guids:)
        response = Api::Value.batch_by_episode_guid(guids: episode_guids)
        # Each item wraps its value block with the episode's details; flatten them into one object. The API omits
        # "value" when nothing matches.
        Array(response["value"]).map { |item| build(item.except("value").merge(item["value"])) }
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

      def build(attributes)
        value = attributes.transform_keys(&:underscore)
        new(JSON.parse(value.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end
    end
  end
end
