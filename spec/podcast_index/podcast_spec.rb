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

  describe ".find_by" do
    subject { described_class.find_by(attribute) }

    context "with feed_url attribute" do
      let(:feed_url) { "http://mp3s.nashownotes.com/pc20rss.xml" }
      let(:attribute) { { feed_url: feed_url } }
      let(:fixture) { file_fixture("podcasts/by_feed_url_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Podcasts).to receive(:by_feed_url).with(hash_including(url: feed_url))
                                                                   .and_return(response)
      end

      its(:url) { is_expected.to eq(feed_url) }
    end

    context "with guid attribute" do
      let(:guid) { "917393e3-1b1e-5cef-ace4-edaa54e1f810" }
      let(:attribute) { { guid: guid } }

      let(:fixture) { file_fixture("podcasts/by_guid_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Podcasts).to receive(:by_guid).with(hash_including(attribute)).and_return(response)
      end

      its(:podcast_guid) { is_expected.to eq(guid) }
    end

    context "with itunes_id attribute" do
      let(:itunes_id) { 1584274529 }
      let(:attribute) { { itunes_id: itunes_id } }
      let(:fixture) { file_fixture("podcasts/by_itunes_id_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Podcasts).to receive(:by_itunes_id).with(hash_including(id: itunes_id))
                                                                    .and_return(response)
      end

      its(:itunes_id) { is_expected.to eq(itunes_id) }
    end
  end

  describe ".where" do
    subject(:podcasts) { described_class.where(attributes) }

    context "with tag attribute" do
      let(:tag) { "podcast-value" }
      let(:attributes) { { tag: tag } }
      let(:fixture) { file_fixture("podcasts/by_tag_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Podcasts).to receive(:by_tag).with(hash_including(attributes)).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains podcasts" do
        expect(podcasts.first.title).to eq("No Agenda")
      end
    end

    context "with medium attribute" do
      let(:medium) { "music" }
      let(:attributes) { { medium: medium } }
      let(:fixture) { file_fixture("podcasts/by_medium_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Podcasts).to receive(:by_medium).with(hash_including(attributes)).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains podcasts" do
        expect(podcasts.first.title).to eq("100% Retro - Live 24/7")
      end

      context "when medium is music and a search term is supplied" do
        let(:term) { "able kirby" }

        let(:attributes) { { medium: "music", term: term } }
        let(:fixture) { file_fixture("search/music_by_term_response.json").read }

        before do
          allow(PodcastIndex::Api::Search).to receive(:music_by_term).with(hash_including(term: term))
                                                                     .and_return(response)
        end

        it { is_expected.to be_an Array }

        it "contains podcasts" do
          expect(podcasts.first.title).to eq("November EP")
        end
      end
    end

    context "with trending attribute" do
      let(:attributes) { { trending: true } }
      let(:fixture) { file_fixture("podcasts/trending_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before { allow(PodcastIndex::Api::Podcasts).to receive(:trending).and_return(response) }

      it { is_expected.to be_an Array }

      it "contains podcasts" do
        expect(podcasts.first.title).to eq("This Week in Tech (Audio)")
      end
    end

    context "with dead attribute" do
      let(:attributes) { { dead: true } }
      let(:fixture) { file_fixture("podcasts/dead_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before { allow(PodcastIndex::Api::Podcasts).to receive(:dead).and_return(response) }

      it { is_expected.to be_an Array }

      it "contains podcasts" do
        expect(podcasts.first.title).to eq("St Neots Evangelical Church Sermons")
      end
    end

    context "with term attribute" do
      let(:term) { "Podcasting 2.0" }
      let(:attributes) { { term: term } }
      let(:fixture) { file_fixture("search/by_term_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Search).to receive(:by_term).with(hash_including(attributes)).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains feeds" do
        expect(podcasts.first.id).to eq(920666)
      end
    end

    context "with title attribute" do
      let(:title) { "Podcasting 2.0" }
      let(:attributes) { { title: title } }
      let(:fixture) { file_fixture("search/by_title_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Search).to receive(:by_title).with(hash_including(attributes)).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains feeds" do
        expect(podcasts.first.id).to eq(920666)
      end
    end

    context "with recent attribute" do
      let(:attributes) { { recent: true } }
      let(:fixture) { file_fixture("recent/feeds_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Recent).to receive(:feeds).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains feeds" do
        expect(podcasts.first.id).to eq(3898903)
      end
    end

    context "with new attribute" do
      let(:attributes) { { new: true } }
      let(:fixture) { file_fixture("recent/new_feeds_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Recent).to receive(:new_feeds).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains feeds" do
        expect(podcasts.first.id).to eq(6330058)
      end
    end
  end
end
