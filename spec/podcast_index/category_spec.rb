RSpec.describe PodcastIndex::Category do
  let(:fixture) { file_fixture("categories/list_response.json").read }
  let(:response) { JSON.parse(fixture) }

  before { allow(PodcastIndex::Api::Categories).to receive(:list).and_return(response) }

  describe ".all" do
    subject(:category) { described_class.all }

    it { is_expected.to be_an(Array) }
    its(:size) { is_expected.to eq(112) }
  end

  describe ".find" do
    subject(:category) { described_class.find(id) }

    let(:id) { 39 }

    its(:id) { is_expected.to eq(39) }
    its(:name) { is_expected.to eq("Pets") }

    context "when not found" do
      let(:id) { 1000 }

      it "raises an error" do
        expect { category }.to raise_error(PodcastIndex::CategoryNotFound)
      end
    end
  end
end
