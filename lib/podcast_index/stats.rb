require "delegate"

module PodcastIndex
  class Stats < SimpleDelegator
    extend Model

    class << self
      def current
        response = Api::Stats.current
        build(response["stats"])
      end
    end
  end
end
