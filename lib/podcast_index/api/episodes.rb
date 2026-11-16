# rubocop:disable Metrics/ParameterLists
module PodcastIndex
  module Api
    class Episodes
      extend Request

      class << self
        # https://podcastindex-org.github.io/docs-api/#get-/episodes/byid
        def by_id(id:, fulltext: nil)
          response = get("/episodes/byid", id: id, fulltext: fulltext)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/byfeedid
        def by_feed_id(id:, since: nil, max: nil, fulltext: nil, enclosure: nil, newest: nil)
          response = get("/episodes/byfeedid", id: Array(id).join(","), since: since, max: max, fulltext: fulltext,
                                               enclosure: enclosure, newest: newest)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/byfeedurl
        def by_feed_url(url:, since: nil, max: nil, fulltext: nil)
          response = get("/episodes/byfeedurl", url: url, since: since, max: max, fulltext: fulltext)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/bypodcastguid
        def by_podcast_guid(podcast_guid:, since: nil, max: nil, fulltext: nil)
          response = get("/episodes/bypodcastguid", guid: podcast_guid, since: since, max: max, fulltext: fulltext)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/byguid
        def by_guid(guid:, feedurl: nil, feedid: nil, podcastguid: nil, fulltext: nil)
          response = get("/episodes/byguid", guid: guid, feedurl: feedurl, feedid: feedid, podcastguid: podcastguid,
                                             fulltext: fulltext)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/byitunesid
        def by_itunes_id(id:, since: nil, max: nil, fulltext: nil, enclosure: nil)
          response = get("/episodes/byitunesid", id: id, since: since, max: max, fulltext: fulltext,
                                                 enclosure: enclosure)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/live
        def live(max: nil)
          response = get("/episodes/live", max: max)
          JSON.parse(response.body)
        end

        # https://podcastindex-org.github.io/docs-api/#get-/episodes/random
        def random(max: nil, lang: nil, cat: nil, notcat: nil, fulltext: nil)
          response = get("/episodes/random", max: max, lang: lang, cat: cat, notcat: notcat, fulltext: fulltext)
          JSON.parse(response.body)
        end
      end
    end
  end
end
# rubocop:enable Metrics/ParameterLists
