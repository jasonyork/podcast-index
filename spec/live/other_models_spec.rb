RSpec.describe "Live API: Value, Soundbite, Category and Stats", :live do # rubocop:disable RSpec/DescribeClass
  let(:feed_id) { 920666 } # Podcasting 2.0

  describe "Value.find_by" do
    it "finds by feed_id" do
      expect(PodcastIndex::Value.find_by(feed_id: feed_id).destinations).not_to be_empty
    end

    it "finds by feed_url" do
      url = PodcastIndex::Podcast.find(feed_id).url
      expect(PodcastIndex::Value.find_by(feed_url: url).destinations).not_to be_empty
    end

    it "finds by podcast_guid" do
      guid = PodcastIndex::Podcast.find(feed_id).podcast_guid
      expect(PodcastIndex::Value.find_by(podcast_guid: guid).destinations).not_to be_empty
    end

    it "finds by podcast_guid and episode_guid" do
      guid = PodcastIndex::Podcast.find(feed_id).podcast_guid
      episode = PodcastIndex::Episode.where(feed_id: feed_id, max: 1).first
      expect(PodcastIndex::Value.find_by(podcast_guid: guid, episode_guid: episode.guid).title).to eq episode.title
    end

    it "raises ValueNotFound for an unknown podcast_guid" do
      expect { PodcastIndex::Value.find_by(podcast_guid: "6b1f6a2e-3c1d-4f7e-9a2b-1c2d3e4f5a6b") }
        .to raise_error(PodcastIndex::ValueNotFound)
    end

    it "raises ValueNotFound for an unknown episode_guid" do
      guid = PodcastIndex::Podcast.find(feed_id).podcast_guid
      expect { PodcastIndex::Value.find_by(podcast_guid: guid, episode_guid: "no-such-episode") }
        .to raise_error(PodcastIndex::ValueNotFound)
    end

    it "raises ValueNotFound for a feed without a value block" do
      expect { PodcastIndex::Value.find_by(feed_id: 999_999_999) }.to raise_error(PodcastIndex::ValueNotFound)
    end
  end

  describe "Soundbite.where" do
    it "finds recent soundbites" do
      expect(PodcastIndex::Soundbite.where(recent: true, max: 3).size).to be_between(1, 3)
    end
  end

  describe "Category" do
    it "lists all categories" do
      expect(PodcastIndex::Category.all.size).to be > 50
    end

    it "finds a category by id" do
      expect(PodcastIndex::Category.find(1).name).to be_present
    end
  end

  describe "Stats.current" do
    it "returns the feed count" do
      expect(PodcastIndex::Stats.current.feed_count_total).to be > 1_000_000
    end
  end
end
