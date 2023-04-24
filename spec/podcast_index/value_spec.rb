RSpec.describe PodcastIndex::Value do
  describe ".find_by" do
    subject(:value) { described_class.find_by(attribute) }

    context "with feed_id attribute" do
      let(:feed_id) { 920666 }
      let(:attribute) { { feed_id: feed_id } }
      let(:fixture) { file_fixture("value/by_feed_id_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_feed_id).with(hash_including(id: feed_id))
                                                               .and_return(response)
      end

      it "has a model type" do
        expect(value.model.type).to eq "lightning"
      end

      it "has destinations" do
        expect(value.destinations.first.name).to eq "Podcastindex.org"
      end
    end

    context "with feed_url attribute" do
      let(:feed_url) { "https://mp3s.nashownotes.com/pc20rss.xml" }
      let(:attribute) { { feed_url: feed_url } }
      let(:fixture) { file_fixture("value/by_feed_url_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_feed_url).with(hash_including(url: feed_url))
                                                                .and_return(response)
      end

      it "has a model type" do
        expect(value.model.type).to eq "lightning"
      end

      it "has destinations" do
        expect(value.destinations.first.name).to eq "Podcastindex.org"
      end
    end
  end
end
