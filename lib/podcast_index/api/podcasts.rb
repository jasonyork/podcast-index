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

        def by_tag(tag:, max: nil, start_at: nil)
          response = get("/podcasts/bytag", { tag => true, max: max, start_at: start_at })
          JSON.parse(response.body)
        end

        def by_medium(medium:, max: nil)
          response = get("/podcasts/bymedium", medium: medium, max: max)
          JSON.parse(response.body)
        end

        def trending(max: nil, since: nil, lang: nil, cat: nil, notcat: nil)
          response = get("/podcasts/trending", max: max, since: since, lang: lang, cat: cat, notcat: notcat)
          JSON.parse(response.body)
        end

        # guids: an array of podcast guids
        def batch_by_guid(guids:)
          response = post("/podcasts/batch/byguid", guids)
          JSON.parse(response.body)
        end

        def dead
          response = get("/podcasts/dead", {})
          JSON.parse(response.body)
        end
      end
    end
  end
end
