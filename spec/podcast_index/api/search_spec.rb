RSpec.describe PodcastIndex::Api::Search do
  describe ".by_term" do
    subject(:result) { described_class.by_term(term: term) }

    let(:fixture) { file_fixture("search/by_term_response.json").read }
    let(:term) { 920666 }

    before do
      stub_request(:get, %r{/search/byterm})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["feeds"][0]["title"]).to eq "Podcasting 2.0"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feeds: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["feeds"]).to eq []
      end
    end
  end

  describe ".by_title" do
    subject(:result) { described_class.by_title(title: title) }

    let(:fixture) { file_fixture("search/by_title_response.json").read }
    let(:title) { "Podcasting 2.0" }

    before do
      stub_request(:get, %r{/search/bytitle})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["feeds"][0]["title"]).to eq "Podcasting 2.0"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feeds: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["feeds"]).to eq []
      end
    end
  end

  describe ".by_person" do
    subject(:result) { described_class.by_person(person: person) }

    let(:fixture) { file_fixture("search/by_person_response.json").read }
    let(:person) { "Adam Curry" }

    before do
      stub_request(:get, %r{/search/byperson})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(result["items"][0]["title"]).to eq "Episode #2: A conversation with Adam Curry"
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: "", items: [], description: "No results found." }.to_json }

      it "returns an empty array for the items" do
        expect(result["items"]).to eq []
      end
    end
  end
end
