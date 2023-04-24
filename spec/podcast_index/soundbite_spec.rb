RSpec.describe PodcastIndex::Soundbite do
  describe ".where" do
    subject(:soundbites) { described_class.where(attributes) }

    context "with recent attribute" do
      let(:attributes) { { recent: true } }
      let(:fixture) { file_fixture("recent/soundbites_response.json").read }
      let(:response) { JSON.parse(fixture) }

      before do
        allow(PodcastIndex::Api::Recent).to receive(:soundbites).and_return(response)
      end

      it { is_expected.to be_an Array }

      it "contains soundbites" do
        expect(soundbites.first.episode_title)
          .to eq("35: 22 Wedding Budget Ideas That Don't Discount Your Style Or Values")
      end
    end
  end
end
