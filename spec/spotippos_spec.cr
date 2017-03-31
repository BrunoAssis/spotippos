require "./spec_helper"

Spec2.describe Spotippos do
  describe "GET /properties/{id}" do
    context "when the id is valid" do
      context "and the property exists" do
        let(new_property) do
          Property.new(
            id: 10000,
            title: "Imóvel código 1000, com 1 quarto e 1 banheiro",
            price: 300000,
            description: "Lorem ipsum",
            lat: 500,
            long: 1000,
            beds: 1,
            baths: 1,
            squareMeters: 100)
        end

        before do
          get "/properties/#{new_property.id}"
        end

        it "returns 200" do
          expect(response.status_code).to eq(200)
        end

        it "returns the property as a JSON" do
          expect(response.body).to eq(new_property.to_json)
        end
      end

      context "and the property doesn't exist" do
        before do
          get "/properties/9999"
        end

        it "returns 404" do
          expect(response.status_code).to eq(404)
        end

        it "returns an error message" do
          error_json = {"error" => "Property doesn't exist."}
          expect(response.body).to eq(error_json)
        end
      end
    end

    context "when the id is invalid" do
      before do
        get "/properties/invalid_id"
      end

      it "returns 404" do
        expect(response.status_code).to eq(404)
      end

      it "returns an error message" do
        error_json = {"error" => "{id} must be an integer."}
        expect(response.body).to eq(error_json)
      end
    end
  end
end
