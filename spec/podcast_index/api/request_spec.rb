module PodcastIndex
  module Api
    class TestService
      extend Request
    end

    RSpec.describe Request do
      describe "constructing the request" do
        subject(:response) { TestService.get("/foo", param1: "bar") }

        context "when not configured" do
          before { PodcastIndex.config.clear }

          it "raises an error" do
            expect { response }.to raise_error(PodcastIndex::Error, "PodcastIndex: base_url must be configured.")
          end

          context "when missing the api_key" do
            before { PodcastIndex.configure { |config| config.api_secret = "ABC" } }

            it "raises an error" do
              expect { response }.to raise_error(PodcastIndex::Error, "PodcastIndex: api_key must be configured.")
            end
          end

          context "when missing the api_secret" do
            before { PodcastIndex.configure { |config| config.api_key = "123" } }

            it "raises an error" do
              expect { response }.to raise_error(PodcastIndex::Error, "PodcastIndex: api_secret must be configured.")
            end
          end
        end

        context "when configured" do
          before do
            stub_request(:get, %r{/foo})
            travel_to(time)
          end

          after { travel_back }

          let(:time) { Time.new(2023, 1, 1, 0, 0, 0, "+00:00") }
          let(:expected_headers) do
            {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Authorization" => "88f9e47ed7f0fb27aee876a772d0b2ae5486f890",
              "User-Agent" => "ruby-nethttp-podcast-index/#{PodcastIndex::VERSION}",
              "X-Auth-Date" => "1672531200",
              "X-Auth-Key" => "123"
            }
          end

          it "supplies the correct url, params and headers" do
            TestService.get("/foo", param1: "bar")
            expect(a_request(:get, "https://api.podcastindex.org/api/1.0/foo?param1=bar")
                     .with { |req| req.headers == expected_headers }).to have_been_made
          end

          it "removes `nil` and `false` params" do
            TestService.get("/foo", param1: "bar", param2: false, param3: nil, param4: true)
            expect(a_request(:get, "https://api.podcastindex.org/api/1.0/foo?param1=bar&param4=true")).to have_been_made
          end
        end

        describe "response handling" do
          subject(:response) { TestService.get("/foo", param1: "bar") }

          context "when a 400 response is returned" do
            let(:response_body) { { status: "false", description: "Invalid parameters" } }

            before { stub_request(:get, %r{/foo}).to_return(status: 400, body: response_body.to_json) }

            it "raises an exception" do
              expect { response }.to raise_error(PodcastIndex::Error, "Invalid parameters")
            end
          end

          context "when a 401 response is returned" do
            let(:response_body) { "The X-Auth-Key header contains an invalid API key.  Please see: https://podcastindex-org.github.io/docs-api/#overview--authentication-details" }

            before { stub_request(:get, %r{/foo}).to_return(status: 401, body: response_body) }

            it "raises an exception" do
              expect { response }.to raise_error(PodcastIndex::Error, /header contains an invalid API key/)
            end
          end
        end
      end
    end
  end
end
