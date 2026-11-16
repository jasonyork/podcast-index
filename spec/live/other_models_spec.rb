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
