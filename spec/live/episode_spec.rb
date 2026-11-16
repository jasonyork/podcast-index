RSpec.describe "Live API: Episode", :live do # rubocop:disable RSpec/DescribeClass
  let(:feed_id) { 920666 } # Podcasting 2.0
  let(:podcast) { PodcastIndex::Podcast.find(feed_id) }
  let(:episode) { PodcastIndex::Episode.where(feed_id: feed_id, max: 1).first }

  describe ".find" do
    it "returns the episode" do
      expect(PodcastIndex::Episode.find(episode.id).guid).to eq episode.guid
    end

    it "raises EpisodeNotFound for an unknown id" do
      expect { PodcastIndex::Episode.find(1) }.to raise_error(PodcastIndex::EpisodeNotFound)
    end
  end

  describe ".find_by" do
    it "finds by guid and feedid" do
      expect(PodcastIndex::Episode.find_by(guid: episode.guid, feedid: feed_id).id).to eq episode.id
    end

    it "finds by guid and feedurl" do
      expect(PodcastIndex::Episode.find_by(guid: episode.guid, feedurl: podcast.url).id).to eq episode.id
    end

    it "raises a plain Error, not EpisodeNotFound, when no feed is given" do
      expect { PodcastIndex::Episode.find_by(guid: episode.guid) }
        .to raise_error(an_instance_of(PodcastIndex::Error), /requires either a valid/)
    end

    it "raises EpisodeNotFound for an unknown guid" do
      expect { PodcastIndex::Episode.find_by(guid: "no-such-guid-#{Time.now.to_i}", feedid: feed_id) }
        .to raise_error(PodcastIndex::EpisodeNotFound)
    end
  end

  describe ".where" do
    it "finds by feed_id" do
      expect(PodcastIndex::Episode.where(feed_id: feed_id, max: 3).map(&:feed_id).uniq).to eq [feed_id]
    end

    it "finds by feed_url" do
      expect(PodcastIndex::Episode.where(feed_url: podcast.url, max: 3).map(&:feed_id).uniq).to eq [feed_id]
    end

    it "finds by podcast_guid" do
      expect(PodcastIndex::Episode.where(podcast_guid: podcast.podcast_guid, max: 3).map(&:feed_id).uniq)
        .to eq [feed_id]
    end

    it "finds by itunes_id" do
      expect(PodcastIndex::Episode.where(itunes_id: podcast.itunes_id, max: 3).map(&:feed_id).uniq).to eq [feed_id]
    end

    it "finds live episodes" do
      expect(PodcastIndex::Episode.where(live: true, max: 3)).to be_an Array
    end

    it "finds by person" do
      expect(PodcastIndex::Episode.where(person: "Adam Curry", max: 3)).not_to be_empty
    end

    it "finds recent episodes" do
      expect(PodcastIndex::Episode.where(recent: true, max: 3).size).to be_between(1, 3)
    end

    it "excludes recent episodes matching exclude_string" do
      titles = PodcastIndex::Episode.where(recent: true, max: 20, exclude_string: "the").map(&:title)
      expect(titles.grep(/the/i)).to be_empty
    end
  end

  describe ".sample" do
    it "returns random episodes" do
      expect(PodcastIndex::Episode.sample(max: 2).size).to be_between(1, 2)
    end
  end
end
