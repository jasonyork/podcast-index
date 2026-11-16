RSpec.describe "Live API: parameters added in 0.6.0", :live do # rubocop:disable RSpec/DescribeClass
  let(:feed_id) { 920666 } # Podcasting 2.0
  let(:other_feed_id) { 75075 } # any second feed with episodes works
  let(:podcast) { PodcastIndex::Podcast.find(feed_id) }
  let(:episodes) { PodcastIndex::Episode.where(feed_id: feed_id, max: 5) }

  describe "Episode.where(feed_id:)" do
    it "accepts an array of feed ids, returning the newest episode of each with newest" do
      result = PodcastIndex::Episode.where(feed_id: [feed_id, other_feed_id], newest: true)
      expect(result.map(&:feed_id)).to contain_exactly(feed_id, other_feed_id)
    end

    it "filters by enclosure" do
      target = episodes.last
      result = PodcastIndex::Episode.where(feed_id: feed_id, enclosure: target.enclosure_url)
      expect(result.map(&:id)).to eq [target.id]
    end
  end

  describe "Episode.where(itunes_id:)" do
    it "filters by enclosure" do
      target = episodes.last
      result = PodcastIndex::Episode.where(itunes_id: podcast.itunes_id, enclosure: target.enclosure_url)
      expect(result.map(&:id)).to eq [target.id]
    end
  end

  describe "Episode.find_by(guid:)" do
    it "finds by guid and podcastguid" do
      target = episodes.first
      expect(PodcastIndex::Episode.find_by(guid: target.guid, podcastguid: podcast.podcast_guid).id).to eq target.id
    end
  end

  describe "Podcast.where" do
    it "accepts similar with term" do
      expect(PodcastIndex::Podcast.where(term: "podcasting 2.0", similar: true, max: 10).map(&:id)).to include feed_id
    end

    it "accepts similar with title" do
      expect(PodcastIndex::Podcast.where(title: "podcasting 2.0", similar: true, max: 10).map(&:id)).to include feed_id
    end

    it "limits tag results with max" do
      expect(PodcastIndex::Podcast.where(tag: "podcast-value", max: 5).size).to eq 5
    end

    it "starts tag results at start_at" do
      first_page = PodcastIndex::Podcast.where(tag: "podcast-value", max: 5)
      next_page = PodcastIndex::Podcast.where(tag: "podcast-value", max: 5, start_at: first_page.last.id + 1)
      expect(next_page.map(&:id)).to all(be > first_page.last.id)
    end

    it "limits medium results with max" do
      pending "The API ignores max on /podcasts/bymedium (returns every matching feed, capped at 10000)"
      expect(PodcastIndex::Podcast.where(medium: "music", max: 5).size).to eq 5
    end
  end
end
