require "../../spec_helper"

module Spotippos::Repositories
  Spec2.describe PropertyRepository do
    subject { PropertyRepository.new }

    describe "#get" do
      context "when there is a property" do
        let(new_property) do
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
            square_meters: 100)
        end

        before do
          repository = Repositories::PropertyRepository.new
          repository.clear
          repository.insert(new_property)
        end

        it "returns the property" do
          expect(subject.get(10_000)).to eq(new_property)
        end
      end

      context "when there is not a property" do
        it "returns nil" do
          expect(subject.get(999)).to eq(nil)
        end
      end
    end

    describe "#insert" do
      context "when there is an id provided" do
        context "and the property does not exist yet" do
          let(a_property) do
            Entities::Property.new(
              id: 10_001,
              title: "Imóvel código 10001, com 1 quarto e 1 banheiro",
              price: 300_000,
              description: "Lorem ipsum",
              x: 500,
              y: 1_000,
              beds: 1,
              baths: 1,
              provinces: ["Gode", "Ruja"],
              square_meters: 100)
          end

          it "the property is inserted and returned" do
            expect(subject.insert(a_property)).to eq(a_property)
          end
        end

        context "and the property already exists" do
          let(new_property) do
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
              square_meters: 100)
          end

          before do
            repository = Repositories::PropertyRepository.new
            repository.clear
            repository.insert(new_property)
          end

          it "the property is not inserted and returns nil" do
            expect(subject.insert(new_property)).to eq(nil)
          end
        end
      end

      context "when there is not an id provided" do
        let(new_property) do
          Entities::Property.new(
            id: nil,
            title: "Imóvel código X, com 1 quarto e 1 banheiro",
            price: 300_000_i64,
            description: "Lorem ipsum",
            x: 500_i64,
            y: 1_000_i64,
            beds: 1_i64,
            baths: 1_i64,
            provinces: ["Gode", "Ruja"],
            square_meters: 100_i64)
        end

        before do
          repository = Repositories::PropertyRepository.new
          repository.clear
        end

        it "an id is generated and the property is inserted and returned" do
          inserted = subject.insert(new_property).as(Entities::Property)
          expect(inserted.id.as(Int64)).to_be > 0
        end
      end
    end

    describe "#all" do
      let(new_property) do
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
          square_meters: 100)
      end

      let(new_property_2) do
        Entities::Property.new(
          id: 10_001,
          title: "Imóvel código 10001, com 1 quarto e 1 banheiro",
          price: 300_000,
          description: "Lorem ipsum",
          x: 500,
          y: 1_000,
          beds: 1,
          baths: 1,
          provinces: ["Gode", "Ruja"],
          square_meters: 100)
      end

      before do
        repository = Repositories::PropertyRepository.new
        repository.clear
        repository.insert(new_property)
        repository.insert(new_property_2)
      end

      it "returns all properties" do
        expect(subject.all.size).to eq(2)
      end
    end

    describe "#clear" do
      let(new_property) do
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
          square_meters: 100)
      end

      before do
        repository = Repositories::PropertyRepository.new
        repository.clear
        repository.insert(new_property)
      end

      it "clears the storage" do
        expect(subject.all.size).to eq(1)
        subject.clear
        expect(subject.all.size).to eq(0)
      end
    end
  end
end
