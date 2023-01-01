require "addressable"
require "digest"
require "net/http"

module PodcastIndex
  module Api
    module Request
      def get(path, params)
        template = Addressable::Template.new("#{base_url}#{path}{?query*}")
        uri = template.expand(query: sanitized_params(params))
        handle_response(response_to(uri))
      end

    private

      def sanitized_params(params)
        # The API only requires boolean params to only be present, so passing param like `clean=false` could provide
        # unexpected results.  This ensures `nil` and `false` values are removed.
        params.select { |_k, v| v.present? }
      end

      def response_to(uri)
        req = Net::HTTP::Get.new(uri)
        add_headers(req)

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
          http.request(req)
        end
      end

      def handle_response(response)
        return response if response.is_a? Net::HTTPSuccess

        message = begin
          JSON.parse(response.body)["description"]
        rescue JSON::ParserError
          response.body.strip.present? ? response.body : response.message
        end
        raise PodcastIndex::Error, message
      end

      def base_url
        raise PodcastIndex::Error, "PodcastIndex: base_url must be configured." unless PodcastIndex.base_url.present?

        PodcastIndex.base_url
      end

      def api_key
        raise PodcastIndex::Error, "PodcastIndex: api_key must be configured." unless PodcastIndex.api_key.present?

        PodcastIndex.api_key
      end

      def api_secret
        unless PodcastIndex.api_secret.present?
          raise PodcastIndex::Error, "PodcastIndex: api_secret must be configured."
        end

        PodcastIndex.api_secret
      end

      def add_headers(request)
        time = Time.now.to_i

        request["User-Agent"] = "ruby-nethttp-podcast-index/#{PodcastIndex::VERSION}"
        request["X-Auth-Key"] = api_key
        request["X-Auth-Date"] = time
        request["Authorization"] = request_digest(time)
      end

      def request_digest(time)
        sha1 = Digest::SHA1.new
        sha1.update [api_key, api_secret, time.to_s].join
        sha1.hexdigest
      end
    end
  end
end
