require "../../spec_helper"

module Spotippos::Controllers::Properties
  Spec2.describe GetAction do
    context "when the id is valid" do
      context "and the property exists" do
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
        let(new_property_json) do
          <<-JSON
            {
              "id": 10000,
              "title": "Imóvel código 10000, com 1 quarto e 1 banheiro",
              "price": 300000,
              "description": "Lorem ipsum",
              "x": 500,
              "y": 1000,
              "beds": 1,
              "baths": 1,
              "provinces": ["Gode", "Ruja"],
              "squareMeters": 100
            }
          JSON
        end
        let(repository) { Repositories::PropertyRepository.new }

        before do
          repository.insert(new_property)
          get "/properties/#{new_property.id}"
        end

        it "returns 200 - OK" do
          expect(response.status_code).to eq(200)
        end

        it "returns the property as a JSON" do
          expect(JSON.parse(response.body)).to eq(JSON.parse(new_property_json))
        end
      end

      context "and the property doesn't exist" do
        before do
          get "/properties/9999"
        end

        it "returns 404 - Not Found" do
          expect(response.status_code).to eq(404)
        end

        it "returns an error message" do
          error_json = {"error" => "Not Found: Property (9999) doesn't exist."}.to_json
          expect(response.body).to eq(error_json)
        end
      end
    end

    context "when the id is invalid" do
      before do
        get "/properties/invalid_id"
      end

      it "returns 400 - Bad Request" do
        expect(response.status_code).to eq(400)
      end

      it "returns an error message" do
        error_json = {"error" => "Bad Request: {id} must be an integer."}.to_json
        expect(response.body).to eq(error_json)
      end
    end
  end
end
