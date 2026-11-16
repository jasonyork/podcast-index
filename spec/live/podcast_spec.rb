RSpec.describe "Live API: Podcast", :live do # rubocop:disable RSpec/DescribeClass
  let(:feed_id) { 920666 } # Podcasting 2.0
  let(:podcast) { PodcastIndex::Podcast.find(feed_id) }

  describe ".find" do
    it "returns the podcast" do
      expect(podcast.title).to eq "Podcasting 2.0"
    end

    it "raises PodcastNotFound for an unknown id" do
      expect { PodcastIndex::Podcast.find(999_999_999) }.to raise_error(PodcastIndex::PodcastNotFound)
    end
  end

  describe ".find_by" do
    it "finds by feed_url" do
      expect(PodcastIndex::Podcast.find_by(feed_url: podcast.url).id).to eq feed_id
    end

    it "finds by guid" do
      expect(PodcastIndex::Podcast.find_by(guid: podcast.podcast_guid).id).to eq feed_id
    end

    it "finds by itunes_id" do
      expect(PodcastIndex::Podcast.find_by(itunes_id: podcast.itunes_id).id).to eq feed_id
    end

    it "raises PodcastNotFound for an unknown guid" do
      # Not all-zeros: a real feed uses that guid.
      expect { PodcastIndex::Podcast.find_by(guid: "6b1f6a2e-3c1d-4f7e-9a2b-1c2d3e4f5a6b") }
        .to raise_error(PodcastIndex::PodcastNotFound)
    end

    it "raises PodcastNotFound for an unknown feed_url" do
      expect { PodcastIndex::Podcast.find_by(feed_url: "https://example.invalid/no-feed.xml") }
        .to raise_error(PodcastIndex::PodcastNotFound)
    end
  end

  describe ".where" do
    it "searches by term" do
      expect(PodcastIndex::Podcast.where(term: "podcasting 2.0", max: 5).map(&:id)).to include feed_id
    end

    it "searches by title" do
      expect(PodcastIndex::Podcast.where(title: "podcasting 2.0", max: 5).map(&:id)).to include feed_id
    end

    it "searches music by term" do
      expect(PodcastIndex::Podcast.where(medium: "music", term: "rock", max: 5)).not_to be_empty
    end

    it "finds by tag" do
      expect(PodcastIndex::Podcast.where(tag: "podcast-value")).not_to be_empty
    end

    it "finds by medium" do
      expect(PodcastIndex::Podcast.where(medium: "music").map(&:medium).uniq).to eq ["music"]
    end

    it "finds trending podcasts" do
      expect(PodcastIndex::Podcast.where(trending: true, max: 5).size).to be_between(1, 5)
    end

    it "finds recent podcasts" do
      expect(PodcastIndex::Podcast.where(recent: true, max: 5).size).to be_between(1, 5)
    end

    it "finds new podcasts" do
      expect(PodcastIndex::Podcast.where(new: true, max: 5).size).to be_between(1, 5)
    end

    it "finds by a batch of guids" do
      guids = [podcast.podcast_guid, PodcastIndex::Podcast.find(41504).podcast_guid] # 41504: No Agenda
      expect(PodcastIndex::Podcast.where(guids: guids).map(&:id)).to contain_exactly(feed_id, 41504)
    end

    it "returns an empty array when no guids in the batch match" do
      expect(PodcastIndex::Podcast.where(guids: ["6b1f6a2e-3c1d-4f7e-9a2b-1c2d3e4f5a6b"])).to eq []
    end

    it "finds podcasts that recently added a value block" do
      expect(PodcastIndex::Podcast.where(new_value: true, max: 3).size).to be_between(1, 3)
    end

    it "finds newly found podcasts" do
      expect(PodcastIndex::Podcast.where(newly_found: true, max: 5).size).to be_between(1, 5)
    end

    it "finds dead podcasts" do
      expect(PodcastIndex::Podcast.where(dead: true)).not_to be_empty
    end
  end
end
