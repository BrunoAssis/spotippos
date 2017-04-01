require "../../spec_helper"

module Spotippos::Controllers::Properties
  Spec2.describe CreateAction do
    before do
      post "/properties",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: payload
    end

    context "when the payload is valid" do
      let(payload) do
        <<-JSON
        {
          "lat": 222,
          "long": 444,
          "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
          "price": 1250000,
          "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          "beds": 4,
          "baths": 3,
          "squareMeters": 210
        }
      JSON
      end

      let(new_property_json) do
        <<-JSON
        {
          "id": 1
          "lat": 222,
          "long": 444,
          "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
          "price": 1250000,
          "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          "beds": 4,
          "baths": 3,
          "provinces": ["Gode", "Ruja"],
          "squareMeters": 210
        }
        JSON
      end

      it "returns 201 - Created" do
        expect(response.status_code).to eq(201)
      end

      it "returns the new property as a JSON" do
        expect(JSON.parse(response.body)).to eq(JSON.parse(new_property_json))
      end
    end

    context "when the payload is invalid" do
      context "because of missing required values" do
        let(payload) do
          <<-JSON
          {
            "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
            "price": 1250000,
            "beds": 4,
            "baths": 3,
            "squareMeters": 210
          }
        JSON
        end

        it "returns 400 - Bad Request" do
          expect(response.status_code).to eq(400)
        end

        it "returns an error message" do
          error_json = {"error" => "Bad Request: Missing values: {lat}, {lng}, {description}"}.to_json
          expect(response.body).to eq(error_json)
        end
      end

      context "because of validation errors" do
        context "and its latitude is invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 1500,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              "beds": 4,
              "baths": 3,
              "squareMeters": 210
            }
            JSON
          end

          it "returns 400 - Bad Request" do
            expect(response.status_code).to eq(400)
          end

          it "returns an error message" do
            error_json = {"error" => "Bad Request: {lat} must be between 0 and 1400"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its longitude is invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 222,
              "long": 1100,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              "beds": 4,
              "baths": 3,
              "squareMeters": 210
            }
            JSON
          end

          it "returns 400 - Bad Request" do
            expect(response.status_code).to eq(400)
          end

          it "returns an error message" do
            error_json = {"error" => "Bad Request: {long} must be between 0 and 1000"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its beds are invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 222,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              "beds": 10,
              "baths": 3,
              "squareMeters": 210
            }
            JSON
          end

          it "returns 400 - Bad Request" do
            expect(response.status_code).to eq(400)
          end

          it "returns an error message" do
            error_json = {"error" => "Bad Request: {beds} must be between 1 and 5"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its baths are invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 222,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              "beds": 4,
              "baths": 0,
              "squareMeters": 210
            }
            JSON
          end

          it "returns 400 - Bad Request" do
            expect(response.status_code).to eq(400)
          end

          it "returns an error message" do
            error_json = {"error" => "Bad Request: {baths} must be between 1 and 4"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its square meters are invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 222,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              "beds": 4,
              "baths": 3,
              "squareMeters": 5
            }
            JSON
          end

          it "returns 400 - Bad Request" do
            expect(response.status_code).to eq(400)
          end

          it "returns an error message" do
            error_json = {"error" => "Bad Request: {squareMeters} must be between 20 and 240"}.to_json
            expect(response.body).to eq(error_json)
          end
        end
      end
    end
  end
end
