require "ostruct"
require "delegate"

module PodcastIndex
  class Stats < SimpleDelegator
    class << self
      def current
        response = Api::Stats.current
        from_response(response)
      end

    private

      def from_response(response)
        value = response["stats"].transform_keys(&:underscore)
        new(JSON.parse(value.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
      end
    end
  end
end
