module PodcastIndex
  module Api
    class Podcasts
      extend Request

      class << self
        def by_feed_id(id:)
          response = get("/podcasts/byfeedid", id: id)
          JSON.parse(response.body)
        end

        def by_feed_url(url:)
          response = get("/podcasts/byfeedurl", url: url)
          JSON.parse(response.body)
        end

        def by_itunes_id(id:)
          response = get("/podcasts/byitunesid", id: id)
          JSON.parse(response.body)
        end

        def by_guid(guid:)
          response = get("/podcasts/byguid", guid: guid)
          JSON.parse(response.body)
        end
      end
    end
  end
end
