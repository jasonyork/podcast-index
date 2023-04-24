module PodcastIndex
  module Api
    class Value
      extend Request

      class << self
        def by_feed_id(id:)
          response = get("/value/byfeedid", id: id)
          JSON.parse(response.body)
        end

        def by_feed_url(url:)
          response = get("/value/byfeedurl", url: url)
          JSON.parse(response.body)
        end
      end
    end
  end
end
