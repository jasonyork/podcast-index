module PodcastIndex
  module Api
    class Stats
      extend Request

      class << self
        def current
          response = get("/stats/current", pretty: false)
          JSON.parse(response.body)
        end
      end
    end
  end
end
