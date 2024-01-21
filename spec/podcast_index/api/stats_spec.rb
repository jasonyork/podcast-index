RSpec.describe PodcastIndex::Api::Stats do
  describe ".current" do
    subject(:response) { described_class.current }

    let(:fixture) { file_fixture("stats/current_response.json").read }

    before do
      stub_request(:get, %r{/stats/current}).to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response.dig("stats", "feedCountTotal")).to eq 4316919
    end
  end
end
