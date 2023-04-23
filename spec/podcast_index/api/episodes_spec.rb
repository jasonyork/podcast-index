RSpec.describe PodcastIndex::Api::Episodes do
  describe ".by_feed_id" do
    subject(:response) { described_class.by_feed_id(id: feed_id) }

    let(:fixture) { file_fixture("episodes/by_feed_id_response.json").read }
    let(:feed_id) { 920666 }

    before do
      stub_request(:get, %r{/episodes/byfeedid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["items"][0]["feedId"]).to eq 920666
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { id: 0 }, items: [], description: "No episodes found for this feed." }.to_json
      end

      it "returns an empty array for the items" do
        expect(response["items"]).to eq []
      end
    end
  end

  describe ".by_feed_url" do
    subject(:response) { described_class.by_feed_url(url: feed_url) }

    let(:fixture) { file_fixture("episodes/by_feed_url_response.json").read }
    let(:feed_url) { "http://mp3s.nashownotes.com/pc20rss.xml" }

    before do
      stub_request(:get, %r{/episodes/byfeedurl})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["items"][0]["feedId"]).to eq 920666
    end

    context "when the feed url is not found" do
      let(:fixture) { { status: true, description: "Feed url not found." }.to_json }

      it "does not return the items key" do
        expect(response["items"]).to be_nil
      end
    end
  end

  describe ".by_podcast_guid" do
    subject(:response) { described_class.by_podcast_guid(podcast_guid: podcast_guid) }

    let(:fixture) { file_fixture("episodes/by_podcast_guid_response.json").read }
    let(:podcast_guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }

    before do
      stub_request(:get, %r{/episodes/bypodcastguid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["items"][0]["feedId"]).to eq 920666
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { id: 0 }, items: [], description: "No episodes found for this feed." }.to_json
      end

      it "returns an empty array for the items" do
        expect(response["items"]).to eq []
      end
    end
  end

  describe ".by_itunes_id" do
    subject(:response) { described_class.by_itunes_id(id: itunes_id) }

    let(:fixture) { file_fixture("episodes/by_itunes_id_response.json").read }
    let(:itunes_id) { 1584274529 }

    before do
      stub_request(:get, %r{/episodes/byitunesid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["items"][0]["feedItunesId"]).to eq itunes_id
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { itunes_id: 9999999999 }, items: [],
          description: "No items found for this itunes id." }.to_json
      end

      it "returns an empty array for the items" do
        expect(response["items"]).to eq []
      end
    end
  end

  describe ".live" do
    subject(:response) { described_class.live }

    let(:fixture) { file_fixture("episodes/live_response.json").read }

    before do
      stub_request(:get, %r{/episodes/live})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["items"][0]["feedTitle"]).to eq "100% Retro - Live 24/7"
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { id: 0 }, items: [], description: "No episodes found for this feed." }.to_json
      end

      it "returns an empty array for the items" do
        expect(response["items"]).to eq []
      end
    end
  end

  describe ".by_guid" do
    subject(:response) { described_class.by_guid(guid: guid) }

    let(:fixture) { file_fixture("episodes/by_guid_response.json").read }
    let(:guid) { "PC2084" }

    before do
      stub_request(:get, %r{/episodes/byguid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["episode"]["guid"]).to eq guid
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, episode: [], description: "Episode not found." }.to_json
      end

      it "returns an empty array for the episode" do
        expect(response["episode"]).to eq []
      end
    end
  end

  describe ".by_id" do
    subject(:response) { described_class.by_id(id: id) }

    let(:fixture) { file_fixture("episodes/by_id_response.json").read }
    let(:id) { 8031009367 }

    before do
      stub_request(:get, %r{/episodes/byid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["episode"]["id"]).to eq id
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, episode: [], description: "Episode not found." }.to_json
      end

      it "returns an empty array for the episode" do
        expect(response["episode"]).to eq []
      end
    end
  end
end
