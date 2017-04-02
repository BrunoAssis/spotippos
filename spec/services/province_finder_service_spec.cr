require "../../spec_helper"

module Spotippos::Services
  class ProvinceMockRepository < Repositories::ProvinceRepository
    def all
      [
        Entities::Province.new(
          name: "Cryja",
          upperLeftBoundary: Entities::GeographicPoint.new(1, 600),
          bottomRightBoundary: Entities::GeographicPoint.new(600, 1)
        ),
        Entities::Province.new(
          name: "Jastal",
          upperLeftBoundary: Entities::GeographicPoint.new(300, 400),
          bottomRightBoundary: Entities::GeographicPoint.new(400, 300)
        ),
        Entities::Province.new(
          name: "Talksmall",
          upperLeftBoundary: Entities::GeographicPoint.new(800, 801),
          bottomRightBoundary: Entities::GeographicPoint.new(801, 800)
        ),
      ]
    end
  end

  Spec2.describe ProvinceFinderService do
    subject { ProvinceFinderService.new(ProvinceMockRepository.new) }
    describe "#in_point" do
      context "when there are provinces in the point" do
        let(point) { Entities::GeographicPoint.new(350, 350) }
        it "returns the provinces" do
          provinces = subject.in_point(point)
          expect(provinces.size).to eq(2)
          expect(provinces[0].name).to eq("Cryja")
          expect(provinces[1].name).to eq("Jastal")
        end
      end

      context "when there are no provinces in the point" do
        let(point) { Entities::GeographicPoint.new(700, 700) }
        it "returns an empty list" do
          expect(subject.in_point(point).size).to eq(0)
        end
      end
    end
  end
end
