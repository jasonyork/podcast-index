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

    context "when the value block is not found" do
      let(:attribute) { { feed_id: 1 } }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_feed_id)
          .and_return({ "status" => "true", "value" => [], "description" => "No value block found." })
      end

      it "raises ValueNotFound" do
        expect { value }.to raise_error(PodcastIndex::ValueNotFound, "No value block found.")
      end
    end

    context "when the API responds that the feed has no value block" do
      let(:attribute) { { feed_url: "https://example.com/feed.xml" } }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_feed_url)
          .and_raise(PodcastIndex::RecordNotFound, "This feed has no value block.")
      end

      it "raises ValueNotFound" do
        expect { value }.to raise_error(PodcastIndex::ValueNotFound, "This feed has no value block.")
      end
    end

    context "with podcast_guid attribute" do
      let(:attribute) { { podcast_guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810" } }
      let(:response) { JSON.parse(file_fixture("value/by_podcast_guid_response.json").read) }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_podcast_guid)
          .with(guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810").and_return(response)
      end

      it "has destinations" do
        expect(value.destinations.first.name).to eq "Podcastindex.org"
      end
    end

    context "with podcast_guid and episode_guid attributes" do
      let(:attribute) { { podcast_guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810", episode_guid: "PC20-278" } }
      let(:response) { JSON.parse(file_fixture("value/by_episode_guid_response.json").read) }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_episode_guid)
          .with(podcast_guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810", episode_guid: "PC20-278").and_return(response)
      end

      it "has the episode title" do
        expect(value.title).to eq 'Episode 278: "1 Billion Tokens!"'
      end

      it "has destinations" do
        expect(value.destinations).not_to be_empty
      end
    end

    context "with episode_guid but no podcast_guid" do
      let(:attribute) { { episode_guid: "PC20-278" } }

      it "raises an ArgumentError" do
        expect { value }.to raise_error(ArgumentError, /podcast_guid/)
      end
    end

    context "when the podcast guid is not found" do
      let(:attribute) { { podcast_guid: "6b1f6a2e-3c1d-4f7e-9a2b-1c2d3e4f5a6b" } }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_podcast_guid)
          .and_return({ "status" => "true", "feed" => [], "description" => "No feeds match this guid." })
      end

      it "raises ValueNotFound" do
        expect { value }.to raise_error(PodcastIndex::ValueNotFound, "No feeds match this guid.")
      end
    end

    context "when the episode guid is not found" do
      let(:attribute) { { podcast_guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810", episode_guid: "no-such-episode" } }

      before do
        allow(PodcastIndex::Api::Value).to receive(:by_episode_guid)
          .and_return({ "status" => "false", "description" => "No episodes match this guid." })
      end

      it "raises ValueNotFound" do
        expect { value }.to raise_error(PodcastIndex::ValueNotFound, "No episodes match this guid.")
      end
    end
  end

  describe ".where" do
    subject(:values) { described_class.where(attributes) }

    context "with episode_guids attribute" do
      let(:guids) { { "917393e3-1b1e-5cef-ace4-edaa54e1f810" => %w[PC20-278 PC20-277] } }
      let(:attributes) { { episode_guids: guids } }
      let(:response) { JSON.parse(file_fixture("value/batch_by_episode_guid_response.json").read) }

      before do
        allow(PodcastIndex::Api::Value).to receive(:batch_by_episode_guid).with(guids: guids).and_return(response)
      end

      it "returns a value for each episode" do
        expect(values.map(&:guid)).to contain_exactly("PC20-278", "PC20-277")
      end

      it "includes the episode details" do
        episode = values.find { |value| value.guid == "PC20-278" }
        expect(episode).to have_attributes(podcast_guid: "917393e3-1b1e-5cef-ace4-edaa54e1f810",
                                           feed_title: "Podcasting 2.0",
                                           title: 'Episode 278: "1 Billion Tokens!"')
      end

      it "flattens the value block" do
        expect(values.first.model.type).to eq "lightning"
      end

      it "has destinations" do
        expect(values.first.destinations).not_to be_empty
      end

      context "when no episodes match" do
        let(:response) do
          { "status" => "false", "allFound" => false, "found" => 0,
            "description" => "No episodes found for this guid combination." }
        end

        it { is_expected.to eq [] }
      end
    end

    context "without a supported attribute" do
      let(:attributes) { { feed_id: 920666 } }

      it "raises an ArgumentError" do
        expect { values }.to raise_error(ArgumentError, /episode_guids/)
      end
    end
  end
end
