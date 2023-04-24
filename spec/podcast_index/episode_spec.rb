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

  describe ".find_by" do
    subject { described_class.find_by(attribute) }

    context "guid attribute" do
      let(:guid) { "PC2084" }
      let(:attribute) { { guid: guid } }
      let(:fixture) { file_fixture("episodes/by_guid_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Episodes).to receive(:by_guid).with(hash_including(attribute)).and_return(response)
      end

      its(:guid) { is_expected.to eq(guid) }
      its(:title) { is_expected.to eq("Episode 84: All Aboard to On-Board!") }
      its(:guid) { is_expected.to eq("PC2084") }
    end
  end

  describe ".where" do
    subject(:episodes) { described_class.where(attributes) }

    context "with feed_id attribute" do
      let(:feed_id) { 8031009367 }
      let(:attributes) { { feed_id: feed_id } }
      let(:fixture) { file_fixture("episodes/by_feed_id_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Episodes).to receive(:by_feed_id).with(hash_including(id: feed_id))
                                                                  .and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.id).to eq(12384062306)
      end
    end

    context "with feed_url attribute" do
      let(:feed_url) { 8031009367 }
      let(:attributes) { { feed_url: feed_url } }
      let(:fixture) { file_fixture("episodes/by_feed_url_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Episodes).to receive(:by_feed_url).with(hash_including(url: feed_url))
                                                                   .and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.id).to eq(12384062306)
      end
    end

    context "with podcast_guid attribute" do
      let(:podcast_guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }
      let(:attributes) { { podcast_guid: podcast_guid } }
      let(:fixture) { file_fixture("episodes/by_podcast_guid_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Episodes).to receive(:by_podcast_guid).with(hash_including(attributes))
                                                                       .and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.id).to eq(15033445987)
      end
    end

    context "with itunes_id attribute" do
      let(:itunes_id) { 1584274529 }
      let(:attributes) { { itunes_id: itunes_id } }
      let(:fixture) { file_fixture("episodes/by_itunes_id_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Episodes).to receive(:by_itunes_id).with(hash_including(id: itunes_id))
                                                                    .and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.id).to eq(12384062306)
      end
    end

    context "with live attribute" do
      let(:attributes) { { live: true } }
      let(:fixture) { file_fixture("episodes/live_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before { allow(PodcastIndex::Api::Episodes).to receive(:live).and_return(response) }

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.feed_title).to eq("100% Retro - Live 24/7")
      end
    end

    context "with person attributes" do
      let(:person) { "Adam Curry" }
      let(:attributes) { { person: person } }

      let(:fixture) { file_fixture("search/by_person_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Search).to receive(:by_person).with(hash_including(attributes))
                                                               .and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.title).to eq("Episode #2: A conversation with Adam Curry")
      end
    end

    context "with recent attribute" do
      let(:attributes) { { recent: true } }
      let(:fixture) { file_fixture("recent/episodes_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before { allow(PodcastIndex::Api::Recent).to receive(:episodes).and_return(response) }

      it { is_expected.to be_an Array }

      it "contains episodes" do
        expect(episodes.first.feed_title).to eq("Petites musiques d'une grande guerre")
      end
    end
  end

  describe ".sample" do
    subject(:episodes) { described_class.sample }

    let(:fixture) { file_fixture("episodes/random_response.json").read }
    let(:response) { JSON.parse(fixture) }

    before { allow(PodcastIndex::Api::Episodes).to receive(:random).and_return(response) }

    it { is_expected.to be_an Array }

    it "contains episodes" do
      expect(episodes.first.title).to eq("10 Surprising Stats and What They Mean")
    end
  end
end
