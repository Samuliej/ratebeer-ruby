require 'rails_helper'

include Helpers

RSpec.describe Beer, type: :model do
  describe "with valid attributes" do
    let(:brewery) { FactoryBot.create(:brewery, name: "Test Brewery", year: 2000) }
    let(:style) { FactoryBot.create(:style) }
    let(:beer) { FactoryBot.create(:beer, name: "testbeer", style: style, brewery: brewery) }

    it "is created with valid attributes" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end

  describe "with invalid attributes" do
    let(:brewery) { FactoryBot.create( :brewery, name: "Test Brewery", year: 2000 )}
    let(:style) { FactoryBot.create(:style) }

    let(:beer1) { Beer.create style: style, brewery: brewery }
    let(:beer2) { Beer.create name: "testbeer", brewery: brewery }
    let(:beer3) { Beer.create name: "testbeer", style: style }
    let(:beer4) { Beer.create name: "testbeer", style: style, brewery_id: 5 }

    it "is not created without a name" do
      expect(beer1).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not created without a style" do
      expect(beer2).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not created without a brewery" do
      expect(beer3).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "gives errors if brewery is not valid" do
      expect(beer4).not_to be_valid
      expect(beer4.errors[:brewery]).to eq(["must exist"])
    end
  end
end
