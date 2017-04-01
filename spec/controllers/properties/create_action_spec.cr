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

      it "returns the new property as a JSON with an id" do
        response_fields = JSON.parse(response.body)
        new_property_fields = JSON.parse(new_property_json)

        expect(response_fields["id"].as_i64).to_be > 0_i64
        expect(response_fields["lat"]).to eq(new_property_fields["lat"])
        expect(response_fields["long"]).to eq(new_property_fields["long"])
        expect(response_fields["title"]).to eq(new_property_fields["title"])
        expect(response_fields["description"]).to eq(new_property_fields["description"])
        expect(response_fields["beds"]).to eq(new_property_fields["beds"])
        expect(response_fields["baths"]).to eq(new_property_fields["baths"])
        expect(response_fields["provinces"]).to eq(new_property_fields["provinces"])
        expect(response_fields["squareMeters"]).to eq(new_property_fields["squareMeters"])
      end
    end

    context "when the payload is invalid" do
      context "because it is missing" do
        let(payload) { nil }

        it "returns 400 - Bad Request" do
          expect(response.status_code).to eq(400)
        end

        it "returns an error message" do
          error_json = {"error" => "Bad Request: Missing payload."}.to_json
          expect(response.body).to eq(error_json)
        end
      end

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
          error_message = "Bad Request: {description} missing, {lat} missing, {long} missing"
          error_json = {"error" => error_message}.to_json
          expect(response.body).to eq(error_json)
        end
      end

      context "because of validation errors" do
        context "and its title is invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 333,
              "long": 444,
              "title": "",
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
            error_json = {"error" => "Bad Request: {title} cannot be blank"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its description is invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 333,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 1250000,
              "description": "",
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
            error_json = {"error" => "Bad Request: {description} cannot be blank"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its price is invalid" do
          let(payload) do
            <<-JSON
            {
              "lat": 333,
              "long": 444,
              "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
              "price": 0,
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
            error_json = {"error" => "Bad Request: {price} must be greater than 0"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

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
