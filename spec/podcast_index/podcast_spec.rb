RSpec.describe PodcastIndex::Podcast do
  describe ".find" do
    subject(:podcast) { described_class.find(id) }

    let(:id) { 920666 }
    let(:fixture) { file_fixture("podcasts/by_feed_id_920666_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Podcasts).to receive(:by_feed_id).and_return(response) }

    its(:id) { is_expected.to eq(id) }
    its(:title) { is_expected.to eq("Podcasting 2.0") }
    its(:podcast_guid) { is_expected.to eq("917393e3-1b1e-5cef-ace4-edaa54e1f810") }

    it "parses nested attributes" do
      expect(podcast.value.destinations[0].name).to eq "Podcastindex.org"
    end
  end

  describe ".find_by_feed_url" do
    subject { described_class.find_by_feed_url(feed_url) }

    let(:feed_url) { "http://mp3s.nashownotes.com/pc20rss.xml" }
    let(:fixture) { file_fixture("podcasts/by_feed_url_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Podcasts).to receive(:by_feed_url).and_return(response) }

    its(:url) { is_expected.to eq(feed_url) }
  end

  describe ".find_by_guid" do
    subject { described_class.find_by_guid(guid) }

    let(:guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }
    let(:fixture) { file_fixture("podcasts/by_guid_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Podcasts).to receive(:by_guid).and_return(response) }

    its(:podcast_guid) { is_expected.to eq(guid) }
  end

  describe ".find_by_itunes_id" do
    subject { described_class.find_by_itunes_id(itunes_id) }

    let(:itunes_id) { 1584274529 }
    let(:fixture) { file_fixture("podcasts/by_itunes_id_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Podcasts).to receive(:by_itunes_id).and_return(response) }

    its(:itunes_id) { is_expected.to eq(itunes_id) }
  end

  describe ".find_by_term" do
    subject(:podcasts) { described_class.find_by_term(term) }

    let(:term) { "Podcasting 2.0" }
    let(:fixture) { file_fixture("search/by_term_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Search).to receive(:by_term).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains feeds" do
      expect(podcasts.first.id).to eq(920666)
    end
  end

  describe ".find_by_title" do
    subject(:podcasts) { described_class.find_by_title(title) }

    let(:title) { "Podcasting 2.0" }
    let(:fixture) { file_fixture("search/by_title_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Search).to receive(:by_title).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains feeds" do
      expect(podcasts.first.id).to eq(920666)
    end
  end
end
