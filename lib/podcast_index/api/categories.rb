module PodcastIndex
  module Api
    class Categories
      extend Request

      class << self
        def list
          response = get("/categories/list", pretty: false)
          JSON.parse(response.body)
        end
      end
    end
  end
end
