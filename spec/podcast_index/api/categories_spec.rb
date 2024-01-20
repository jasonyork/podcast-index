RSpec.describe PodcastIndex::Api::Categories do
  describe ".list" do
    subject(:response) { described_class.list }

    let(:fixture) { file_fixture("categories/list_response.json").read }

    before do
      stub_request(:get, %r{/categories/list})
        .to_return(body: fixture, status: 200)
    end

    it "returns the body of the response" do
      expect(response.dig("feeds", 0, "name")).to eq "Arts"
    end
  end
end
