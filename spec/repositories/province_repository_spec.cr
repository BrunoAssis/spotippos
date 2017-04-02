require "../../spec_helper"

module Spotippos::Repositories
  Spec2.describe ProvinceRepository do
    subject { ProvinceRepository.new }

    describe "#get" do
      context "when there is a province" do
        let(new_province) do
          Entities::Province.new(
            name: "Cryja",
            upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
            bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
          )
        end

        before do
          repository = Repositories::ProvinceRepository.new
          repository.clear
          repository.insert(new_province)
        end

        it "returns the province" do
          expect(subject.get("Cryja")).to eq(new_province)
        end
      end

      context "when there is not a province" do
        it "returns nil" do
          expect(subject.get("Jastal")).to eq(nil)
        end
      end
    end

    describe "#insert" do
      context "when the province does not exist yet" do
        let(a_province) do
          Entities::Province.new(
            name: "Brainspeare",
            upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
            bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
          )
        end

        it "the province is inserted and returned" do
          expect(subject.insert(a_province)).to eq(a_province)
        end
      end

      context "when the province already exists" do
        let(new_province) do
          Entities::Province.new(
            name: "Brainspeare",
            upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
            bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
          )
        end

        before do
          repository = Repositories::ProvinceRepository.new
          repository.clear
          repository.insert(new_province)
        end

        it "the province is not inserted and returns nil" do
          expect(subject.insert(new_province)).to eq(nil)
        end
      end
    end

    describe "#all" do
      let(new_province) do
        Entities::Province.new(
          name: "Brainspeare",
          upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
          bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
        )
      end

      let(new_province_2) do
        Entities::Province.new(
          name: "Arnolpiet",
          upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
          bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
        )
      end

      before do
        repository = Repositories::ProvinceRepository.new
        repository.clear
        repository.insert(new_province)
        repository.insert(new_province_2)
      end

      it "returns all properties" do
        expect(subject.all.size).to eq(2)
      end
    end

    describe "#clear" do
      let(new_province) do
        Entities::Province.new(
          name: "Brainspeare",
          upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
          bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
        )
      end

      before do
        repository = Repositories::ProvinceRepository.new
        repository.clear
        repository.insert(new_province)
      end

      it "clears the storage" do
        expect(subject.all.size).to eq(1)
        subject.clear
        expect(subject.all.size).to eq(0)
      end
    end
  end
end
