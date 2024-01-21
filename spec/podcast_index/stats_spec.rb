RSpec.describe PodcastIndex::Stats do
  describe ".current" do
    subject(:stats) { described_class.current }

    context "with recent attribute" do
      let(:fixture) { file_fixture("stats/current_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before { allow(PodcastIndex::Api::Stats).to receive(:current).and_return(response) }

      its(:feed_count_total) { is_expected.to eq(4316919) }
      its(:feeds_with_value_blocks) { is_expected.to eq(17884) }
    end
  end
end
