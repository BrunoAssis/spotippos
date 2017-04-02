require "../../spec_helper"

module Spotippos::Services
  class PropertyMockRepository < Repositories::PropertyRepository
    def all
      [
        Entities::Property.new(
          id: 10_000,
          title: "Imóvel código 10000, com 1 quarto e 1 banheiro",
          price: 300_000,
          description: "Lorem ipsum",
          x: 500,
          y: 1_000,
          beds: 1,
          baths: 1,
          provinces: ["Gode", "Ruja"],
          square_meters: 100),
        Entities::Property.new(
          id: 10_001,
          title: "Imóvel código 10001, com 1 quarto e 1 banheiro",
          price: 300_000,
          description: "Lorem ipsum",
          x: 100,
          y: 200,
          beds: 1,
          baths: 1,
          provinces: ["Gode", "Ruja"],
          square_meters: 100),
      ]
    end
  end

  Spec2.describe PropertyFinderService do
    subject { PropertyFinderService.new(PropertyMockRepository.new) }
    describe "#in_area" do
      context "when there are properties in the area" do
        let(upperLeftPoint) { Entities::GeographicPoint.new(99, 201) }
        let(bottomRightPoint) { Entities::GeographicPoint.new(101, 199) }
        it "returns the properties" do
          properties = subject.in_area(upperLeftPoint, bottomRightPoint)
          expect(properties.size).to eq(1)
          expect(properties[0].id).to eq(10_001)
        end
      end

      context "when there are no properties in the area" do
        let(upperLeftPoint) { Entities::GeographicPoint.new(1, 1000) }
        let(bottomRightPoint) { Entities::GeographicPoint.new(2, 999) }
        it "returns an empty list" do
          expect(subject.in_area(upperLeftPoint, bottomRightPoint).size).to eq(0)
        end
      end
    end
  end
end
