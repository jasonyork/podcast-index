require "delegate"

module PodcastIndex
  class Soundbite < SimpleDelegator
    extend Model

    class << self
      FIND_MANY_ATTRIBUTES = %i[recent].freeze

      def where(attributes)
        key = lookup_attribute(attributes, FIND_MANY_ATTRIBUTES)
        send("find_all_by_#{key}", **attributes)
      end

      def find_all_by_recent(recent:, max: nil) # rubocop:disable Lint/UnusedMethodArgument
        response = Api::Recent.soundbites(max: max)
        build_all(response["items"])
      end
    end
  end
end
