require "ostruct"
require "delegate"

module PodcastIndex
  # Class methods shared by the domain models (which `extend` this module): building model objects from API hashes
  # and choosing the lookup from the attributes given to `find_by` / `where`.
  module Model
  private

    # Wraps an API hash in a model object, exposing its keys as underscored attribute names (`lastUpdateTime` becomes
    # `last_update_time`). Nested hashes become nested objects.
    def build(attributes)
      underscored = attributes.transform_keys(&:underscore)
      new(JSON.parse(underscored.to_json, object_class: OpenStruct)) # rubocop:disable Style/OpenStructUse
    end

    # Builds a model for each item. The API omits the list entirely for some empty results, so nil gives [].
    def build_all(items)
      Array(items).map { |item| build(item) }
    end

    # Returns the one key of `attributes` that is in `allowed`, or raises ArgumentError.
    def lookup_attribute(attributes, allowed)
      match = attributes.keys & allowed
      raise ArgumentError, "Must supply one of the attributes: #{allowed}" if match.empty?
      raise ArgumentError, "Must supply only one of the attributes: #{allowed}" if match.length > 1

      match.first
    end
  end
end
