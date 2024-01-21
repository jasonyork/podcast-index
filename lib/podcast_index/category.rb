require "ostruct"
require "delegate"

module PodcastIndex
  class Category < SimpleDelegator
    class << self
      def find(id)
        category = all.detect { |element| element.id == id }
        raise PodcastIndex::CategoryNotFound if category.nil?

        category
      end

      def all
        response = Api::Categories.list
        from_response_collection(response)
      end

    private

      def from_response_collection(response, collection_key = "feeds")
        response[collection_key].map do |item|
          category = item.transform_keys(&:underscore)
          new(JSON.parse(category.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
        end
      end
    end
  end
end
