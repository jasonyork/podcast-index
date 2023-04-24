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
      end
    end
  end
end
