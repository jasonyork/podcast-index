require "ostruct"
require "delegate"

module PodcastIndex
  class Value < SimpleDelegator
    class << self

      FIND_ONE_ATTRIBUTES = %i[feed_id].freeze

      def find_by(attributes)
        match = (attributes.keys & FIND_ONE_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_ONE_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_ONE_ATTRIBUTES}" if match.length > 1

        send("find_by_#{match.first}", attributes[match.first])
      end

    private

      def find_by_feed_id(feed_id)
        response = Api::Value.by_feed_id(id: feed_id)
        from_response(response)
      end

      def from_response(response)
        value = response["value"].transform_keys(&:underscore)
        new(JSON.parse(value.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end
    end
  end
end
