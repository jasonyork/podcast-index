RSpec.describe PodcastIndex::Api::Recent do
  describe ".episodes" do
    subject(:result) { described_class.episodes }

    let(:fixture) { file_fixture("recent/episodes_response.json").read }

    before do
      stub_request(:get, %r{/recent/episodes})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["items"][0]["title"]).to eq "Retrouvez tous les épisodes sur l’appli Radio France"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feeds: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["feeds"]).to eq []
      end
    end
  end

  describe ".feeds" do
    subject(:result) { described_class.feeds }

    let(:fixture) { file_fixture("recent/feeds_response.json").read }

    before do
      stub_request(:get, %r{/recent/feeds})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["feeds"][0]["title"]).to eq "Los Truck Savers"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feeds: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["feeds"]).to eq []
      end
    end
  end

  describe ".new_feeds" do
    subject(:result) { described_class.new_feeds }

    let(:fixture) { file_fixture("recent/new_feeds_response.json").read }

    before do
      stub_request(:get, %r{/recent/newfeeds})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["feeds"][0]["id"]).to eq 6330058
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feeds: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["feeds"]).to eq []
      end
    end
  end
end
