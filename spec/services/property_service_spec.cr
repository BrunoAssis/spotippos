require "../../spec_helper"

module Spotippos::Services
  class PropertyServicePropertyMockRepository < Repositories::PropertyRepository
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
      ]
    end

    def insert(a_property)
      a_property
    end
  end

  class PropertyServiceProvinceMockRepository < Repositories::ProvinceRepository
    def all
      [
        Entities::Province.new(
          name: "Cryja",
          upperLeftBoundary: Entities::GeographicPoint.new(1, 600),
          bottomRightBoundary: Entities::GeographicPoint.new(600, 1)
        ),
      ]
    end
  end

  class ProvinceFinderMockService < Services::ProvinceFinderService
    def initialize
      @province_repository = PropertyServiceProvinceMockRepository.new
    end

    def in_point(point)
      @province_repository.all
    end
  end

  class PropertyFinderMockService < Services::PropertyFinderService
    def initialize
      @property_repository = PropertyServicePropertyMockRepository.new
    end

    def in_area(upperLeftPoint, bottomRightPoint)
      @property_repository.all
    end
  end

  Spec2.describe PropertyService do
    subject do
      PropertyService.new(PropertyServicePropertyMockRepository.new,
        ProvinceFinderMockService.new,
        PropertyFinderMockService.new)
    end

    describe "#build" do
      it "builds a property object with its provinces found" do
        built_property = subject.build(id: 1_i64,
          title: "Title",
          price: 100_000_i64,
          description: "Description",
          x: 150_i64,
          y: 200_i64,
          beds: 3_i64,
          baths: 4_i64,
          square_meters: 100_i64)
        expect(built_property.id).to eq(1)
        expect(built_property.provinces).to eq(["Cryja"])
      end
    end

    describe "#create" do
      it "inserts the property into the repository" do
        a_property = Entities::Property.new(
          id: 10_000,
          title: "Imóvel código 10000, com 1 quarto e 1 banheiro",
          price: 300_000,
          description: "Lorem ipsum",
          x: 500,
          y: 1_000,
          beds: 1,
          baths: 1,
          provinces: ["Gode", "Ruja"],
          square_meters: 100)
        expect(subject.create(a_property)).to eq(a_property)
      end
    end

    describe "#search" do
      it "calls the property_finder_service with the given points" do
        found_properties = subject.search(1, 2, 3, 4)
        expect(found_properties.size).to eq(1)
        expect(found_properties[0].id).to eq(10_000)
      end
    end
  end
end
