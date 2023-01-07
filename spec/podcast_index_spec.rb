RSpec.describe PodcastIndex do
  it "has a version number" do
    expect(PodcastIndex::VERSION).not_to be_nil
  end

  describe ".configure" do
    before { described_class.configure { |config| config.api_key = "123-456-789" } }

    its(:api_key) { is_expected.to eq("123-456-789") }
  end

  describe ".base_url" do
    its(:base_url) { is_expected.to eq("https://api.podcastindex.org/api/1.0") }
  end
end
