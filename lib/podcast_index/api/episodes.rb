module PodcastIndex
  module Api
    class Episodes
      extend Request

      class << self
        def by_id(id:, fulltext: nil)
          response = get("/episodes/byid", id: id, fulltext: fulltext)
          JSON.parse(response.body)
        end

        def by_feed_id(id:, since: nil, max: nil, fulltext: nil)
          response = get("/episodes/byfeedid", id: id, since: since, max: max, fulltext: fulltext)
          JSON.parse(response.body)
        end

        def by_feed_url(url:, since: nil, max: nil, fulltext: nil)
          response = get("/episodes/byfeedurl", url: url, since: since, max: max, fulltext: fulltext)
          JSON.parse(response.body)
        end

        def by_guid(guid:, feedurl: nil, feedid: nil, fulltext: nil)
          response = get("/episodes/byguid", guid: guid, feedurl: feedurl, feedid: feedid, fulltext: fulltext)
          JSON.parse(response.body)
        end

        def by_itunes_id(id:, since: nil, max: nil, fulltext: nil)
          response = get("/episodes/byitunesid", id: id, since: since, max: max, fulltext: fulltext)
          JSON.parse(response.body)
        end
      end
    end
  end
end
