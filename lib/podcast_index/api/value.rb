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

        def by_podcast_guid(guid:)
          response = get("/value/bypodcastguid", guid: guid)
          JSON.parse(response.body)
        end

        def by_episode_guid(podcast_guid:, episode_guid:)
          response = get("/value/byepisodeguid", podcastguid: podcast_guid, episodeguid: episode_guid)
          JSON.parse(response.body)
        end
      end
    end
  end
end
