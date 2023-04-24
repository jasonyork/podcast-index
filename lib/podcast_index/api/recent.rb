module PodcastIndex
  module Api
    class Recent
      extend Request

      class << self
        def episodes(max: nil, exclude_string: nil, before: nil, fulltext: nil)
          response = get("/recent/episodes", max: max, exclude_string: exclude_string, before: before,
                                             fulltext: fulltext)
          JSON.parse(response.body)
        end

        def feeds(max: nil, since: nil, lang: nil, cat: nil, notcat: nil)
          response = get("/recent/feeds", max: max, since: since, lang: lang, cat: cat, notcat: notcat)
          JSON.parse(response.body)
        end

        def new_feeds(max: nil, since: nil, feedid: nil, desc: nil)
          response = get("/recent/newfeeds", max: max, since: since, feedid: feedid, desc: desc)
          JSON.parse(response.body)
        end
      end
    end
  end
end
