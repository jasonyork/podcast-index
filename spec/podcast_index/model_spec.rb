RSpec.describe PodcastIndex::Model do
  let(:model_class) do
    Class.new(SimpleDelegator) do
      extend PodcastIndex::Model

      class << self
        public :build, :build_all, :lookup_attribute
      end
    end
  end

  describe ".build" do
    subject(:model) { model_class.build("feedId" => 920666, "value" => { "model" => { "type" => "lightning" } }) }

    it { is_expected.to be_a model_class }

    it "underscores the attribute names" do
      expect(model.feed_id).to eq 920666
    end

    it "builds nested objects" do
      expect(model.value.model.type).to eq "lightning"
    end
  end

  describe ".build_all" do
    it "builds a model for each item" do
      expect(model_class.build_all([{ "id" => 1 }, { "id" => 2 }]).map(&:id)).to eq [1, 2]
    end

    it "returns an empty array for nil" do
      expect(model_class.build_all(nil)).to eq []
    end
  end

  describe ".lookup_attribute" do
    it "returns the one supported attribute" do
      expect(model_class.lookup_attribute({ guid: "x", max: 5 }, %i[guid feed_url])).to eq :guid
    end

    it "raises when no supported attribute is given" do
      expect { model_class.lookup_attribute({ max: 5 }, %i[guid feed_url]) }
        .to raise_error(ArgumentError, "Must supply one of the attributes: [:guid, :feed_url]")
    end

    it "raises when more than one supported attribute is given" do
      expect { model_class.lookup_attribute({ guid: "x", feed_url: "y" }, %i[guid feed_url]) }
        .to raise_error(ArgumentError, "Must supply only one of the attributes: [:guid, :feed_url]")
    end
  end
end
