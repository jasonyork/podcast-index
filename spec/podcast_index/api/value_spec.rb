RSpec.describe PodcastIndex::Api::Value do
  describe ".by_feed_id" do
    subject(:result) { described_class.by_feed_id(id: id) }

    let(:fixture) { file_fixture("value/by_feed_id_response.json").read }
    let(:id) { 920666 }

    before do
      stub_request(:get, %r{/value/byfeedid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["value"]["model"]["type"]).to eq "lightning"
      expect(result["value"]["destinations"][0]["name"]).to eq "Podcastindex.org"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, value: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["value"]).to eq []
      end
    end
  end
end
