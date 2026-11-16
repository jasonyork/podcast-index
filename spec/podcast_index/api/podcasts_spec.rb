RSpec.describe PodcastIndex::Api::Podcasts do
  describe ".by_feed_id" do
    subject(:response) { described_class.by_feed_id(id: feed_id) }

    let(:fixture) { file_fixture("podcasts/by_feed_id_920666_response.json").read }
    let(:feed_id) { 920666 }

    before do
      stub_request(:get, %r{/podcasts/byfeedid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feed"]["id"]).to eq 920666
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { id: 0 }, feed: [], description: "No feeds match this id." }.to_json }

      it "returns an empty array for the feed" do
        expect(response["feed"]).to eq []
      end
    end
  end

  describe ".by_feed_url" do
    subject(:response) { described_class.by_feed_url(url: feed_url) }

    let(:fixture) { file_fixture("podcasts/by_feed_url_response.json").read }
    let(:feed_url) { "http://mp3s.nashownotes.com/pc20rss.xml" }

    before do
      stub_request(:get, %r{/podcasts/byfeedurl})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feed"]["url"]).to eq feed_url
    end

    context "when no results were found" do
      let(:fixture) { { status: true, query: { feed_url: 0 }, feed: [], description: "Feed url not found." }.to_json }

      it "returns an empty array for the feed" do
        expect(response["feed"]).to eq []
      end
    end
  end

  describe ".by_itunes_id" do
    subject(:response) { described_class.by_itunes_id(id: itunes_id) }

    let(:fixture) { file_fixture("podcasts/by_itunes_id_response.json").read }
    let(:itunes_id) { 1584274529 }

    before do
      stub_request(:get, %r{/podcasts/byitunesid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feed"]["itunesId"]).to eq itunes_id
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { itunes_id: 0 }, feed: [], description: "No feeds match this itunes id." }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feed"]).to eq []
      end
    end
  end

  describe ".by_guid" do
    subject(:response) { described_class.by_guid(guid: guid) }

    let(:fixture) { file_fixture("podcasts/by_guid_response.json").read }
    let(:guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }

    before do
      stub_request(:get, %r{/podcasts/byguid})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feed"]["podcastGuid"]).to eq guid
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, query: { guid: "1" }, feed: [], description: "No feeds match this guid." }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feed"]).to eq []
      end
    end
  end

  describe ".by_tag" do
    subject(:response) { described_class.by_tag(tag: tag) }

    let(:fixture) { file_fixture("podcasts/by_tag_response.json").read }
    let(:tag) { "podcast-value" }

    before do
      stub_request(:get, %r{/podcasts/bytag})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feeds"][0]["title"]).to eq "No Agenda"
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, feeds: [], description: "No feeds match this guid." }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feeds"]).to eq []
      end
    end

    context "with max and start_at" do
      subject(:response) do
        described_class.by_tag(tag: tag, max: 10, start_at: 920666)
      end

      it "sends the max and start_at parameters" do
        response
        expect(WebMock).to have_requested(:get, %r{/podcasts/bytag})
          .with(query: hash_including("max" => "10", "start_at" => "920666"))
      end
    end
  end

  describe ".by_medium" do
    subject(:response) { described_class.by_medium(medium: medium) }

    let(:fixture) { file_fixture("podcasts/by_medium_response.json").read }
    let(:medium) { "podcast-value" }

    before do
      stub_request(:get, %r{/podcasts/bymedium})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feeds"][0]["title"]).to eq "100% Retro - Live 24/7"
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, feeds: [], description: "Not found" }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feeds"]).to eq []
      end
    end

    context "with max" do
      subject(:response) do
        described_class.by_medium(medium: medium, max: 10)
      end

      it "sends the max parameter" do
        response
        expect(WebMock).to have_requested(:get, %r{/podcasts/bymedium})
          .with(query: hash_including("max" => "10"))
      end
    end
  end

  describe ".trending" do
    subject(:response) { described_class.trending }

    let(:fixture) { file_fixture("podcasts/trending_response.json").read }

    before do
      stub_request(:get, %r{/podcasts/trending})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feeds"][0]["title"]).to eq "This Week in Tech (Audio)"
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, feeds: [], description: "Not found" }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feeds"]).to eq []
      end
    end
  end

  describe ".dead" do
    subject(:response) { described_class.dead }

    let(:fixture) { file_fixture("podcasts/dead_response.json").read }

    before do
      stub_request(:get, %r{/podcasts/dead})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response["feeds"][0]["title"]).to eq "St Neots Evangelical Church Sermons"
    end

    context "when no results were found" do
      let(:fixture) do
        { status: true, feeds: [], description: "Not found" }.to_json
      end

      it "returns an empty array for the feed" do
        expect(response["feeds"]).to eq []
      end
    end
  end

  describe ".batch_by_guid" do
    subject(:response) { described_class.batch_by_guid(guids: guids) }

    let(:guids) { %w[917393e3-1b1e-5cef-ace4-edaa54e1f810 c73b1a23-1c28-5edb-94c3-10d1745d0877] }

    let(:fixture) { file_fixture("podcasts/batch_by_guid_response.json").read }

    before do
      stub_request(:post, %r{/podcasts/batch/byguid})
        .to_return(body: fixture, status: 200)
    end

    it "posts the guids as a JSON array" do
      response
      expect(WebMock).to have_requested(:post, %r{/podcasts/batch/byguid})
        .with(body: guids.to_json)
    end

    it "returns the feeds" do
      expect(response["feeds"].map { |feed| feed["id"] }).to eq [920666, 41504]
    end
  end
end
