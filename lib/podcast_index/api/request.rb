require "addressable"
require "digest"
require "net/http"
require "openssl"

module PodcastIndex
  module Api
    module Request
      # The API answers some lookups for a missing record with HTTP 400 rather than an empty result. It also uses
      # 400 for invalid requests, so the description is the only way to tell them apart.
      NOT_FOUND_DESCRIPTION = /not found|has no value block/i

      DEFAULT_OPEN_TIMEOUT = 10
      DEFAULT_READ_TIMEOUT = 60

      # Failures to reach the API at all (timeouts, DNS, refused or dropped connections, TLS).
      NETWORK_ERRORS = [Timeout::Error, SocketError, SystemCallError, IOError, OpenSSL::SSL::SSLError,
                        Net::ProtocolError, Net::HTTPBadResponse].freeze

      def get(path, params)
        template = Addressable::Template.new("#{base_url}#{path}{?query*}")
        uri = URI(template.expand(query: sanitized_params(params)).to_s)
        handle_response(response_to(Net::HTTP::Get.new(uri)))
      end

      # Sends `body` as JSON, for the batch endpoints.
      def post(path, body)
        request = Net::HTTP::Post.new(URI("#{base_url}#{path}"))
        request["Content-Type"] = "application/json"
        request.body = body.to_json
        handle_response(response_to(request))
      end

    private

      def sanitized_params(params)
        # The API only requires boolean params to only be present, so passing param like `clean=false` could provide
        # unexpected results.  This ensures `nil` and `false` values are removed.
        params.select { |_k, v| v.present? }
      end

      def response_to(request)
        add_headers(request)
        uri = request.uri

        Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https", **timeouts) do |http|
          http.request(request)
        end
      rescue *NETWORK_ERRORS => e
        raise PodcastIndex::Error, "PodcastIndex: network error (#{e.class}: #{e.message})"
      end

      def timeouts
        {
          open_timeout: PodcastIndex.open_timeout || DEFAULT_OPEN_TIMEOUT,
          read_timeout: PodcastIndex.read_timeout || DEFAULT_READ_TIMEOUT
        }
      end

      def handle_response(response)
        return response if response.is_a? Net::HTTPSuccess

        message = error_message(response)
        raise PodcastIndex::RecordNotFound, message if not_found?(response, message)

        raise PodcastIndex::Error, message
      end

      def error_message(response)
        JSON.parse(response.body)["description"]
      rescue JSON::ParserError
        response.body.strip.present? ? response.body : response.message
      end

      def not_found?(response, message)
        %w[400 404].include?(response.code) && message.to_s.match?(NOT_FOUND_DESCRIPTION)
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
