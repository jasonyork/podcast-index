RSpec.describe PodcastIndex::Episode do
  describe ".find" do
    subject(:episode) { described_class.find(id) }

    let(:id) { 8031009367 }
    let(:fixture) { file_fixture("episodes/by_id_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_id).and_return(response) }

    its(:id) { is_expected.to eq(id) }
    its(:title) { is_expected.to eq("Episode 84: All Aboard to On-Board!") }
    its(:guid) { is_expected.to eq("PC2084") }

    it "parses nested attributes" do
      expect(episode.value.destinations[0].name).to eq "Podcastindex.org"
    end
  end

  describe ".find_by_feed_id" do
    subject(:episodes) { described_class.find_by_feed_id(feed_id) }

    let(:feed_id) { 8031009367 }
    let(:fixture) { file_fixture("episodes/by_feed_id_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_feed_id).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.id).to eq(12384062306)
    end
  end

  describe ".find_by_feed_url" do
    subject(:episodes) { described_class.find_by_feed_url(feed_url) }

    let(:feed_url) { 8031009367 }
    let(:fixture) { file_fixture("episodes/by_feed_url_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_feed_url).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.id).to eq(12384062306)
    end
  end

  describe ".find_by_podcast_guid" do
    subject(:episodes) { described_class.find_by_podcast_guid(podcast_guid) }

    let(:podcast_guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }
    let(:fixture) { file_fixture("episodes/by_podcast_guid_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_podcast_guid).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.id).to eq(15033445987)
    end
  end

  describe ".find_by_guid" do
    subject { described_class.find_by_guid(guid, feedurl: "http://mp3s.nashownotes.com/pc20rss.xml") }

    let(:guid) { "PC2084" }
    let(:fixture) { file_fixture("episodes/by_guid_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_guid).and_return(response) }

    its(:guid) { is_expected.to eq(guid) }
    its(:title) { is_expected.to eq("Episode 84: All Aboard to On-Board!") }
    its(:guid) { is_expected.to eq("PC2084") }
  end

  describe ".find_by_itunes_id" do
    subject(:episode) { described_class.find_by_itunes_id(itunes_id) }

    let(:itunes_id) { 1584274529 }
    let(:fixture) { file_fixture("episodes/by_itunes_id_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:by_itunes_id).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episode.first.id).to eq(12384062306)
    end
  end

  describe ".find_by_live_item" do
    subject(:episodes) { described_class.find_by_live_item }

    let(:fixture) { file_fixture("episodes/live_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:live).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.feed_title).to eq("100% Retro - Live 24/7")
    end
  end

  describe ".find_by_person" do
    subject(:episodes) { described_class.find_by_person(person) }

    let(:person) { "Adam Curry" }
    let(:fixture) { file_fixture("search/by_person_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Search).to receive(:by_person).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.title).to eq("Episode #2: A conversation with Adam Curry")
    end
  end
end
