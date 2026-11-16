require "delegate"

module PodcastIndex
  class Category < SimpleDelegator
    extend Model

    class << self
      def find(id)
        category = all.detect { |element| element.id == id }
        raise PodcastIndex::CategoryNotFound if category.nil?

        category
      end

      def all
        response = Api::Categories.list
        build_all(response["feeds"])
      end
    end
  end
end
