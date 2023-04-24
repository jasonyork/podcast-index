require "ostruct"
require "delegate"

module PodcastIndex
  class Soundbite < SimpleDelegator
    class << self
      FIND_MANY_ATTRIBUTES = %i[recent].freeze

      def where(attributes)
        match = (attributes.keys & FIND_MANY_ATTRIBUTES)
        raise ArgumentError, "Must supply one of the attributes: #{FIND_MANY_ATTRIBUTES}" unless match.present?
        raise ArgumentError, "Must supply only one of the attributes: #{FIND_MANY_ATTRIBUTES}" if match.length > 1

        send("find_all_by_#{match.first}", **attributes)
      end

      def find_all_by_recent(recent:, max: nil) # rubocop:disable Lint/UnusedMethodArgument
        response = Api::Recent.soundbites(max: max)
        from_response_collection(response)
      end

      def from_response_collection(response, collection_key = "items")
        response[collection_key].map do |item|
          soundbite = item.transform_keys(&:underscore)
          new(JSON.parse(soundbite.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
