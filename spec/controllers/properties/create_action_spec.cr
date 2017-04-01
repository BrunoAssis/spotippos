require "../../spec_helper"

module Spotippos::Controllers::Properties
  Spec2.describe CreateAction do
    before do
      bigga_province = Entities::Province.new(
        name: "Bigga",
        upperLeftBoundary: Entities::GeographicPoint.new(1, 1000),
        bottomRightBoundary: Entities::GeographicPoint.new(1000, 1)
      )

      smalla_province = Entities::Province.new(
        name: "Smalla",
        upperLeftBoundary: Entities::GeographicPoint.new(1001, 900),
        bottomRightBoundary: Entities::GeographicPoint.new(1002, 901)
      )

      intersecta_province = Entities::Province.new(
        name: "Intersecta",
        upperLeftBoundary: Entities::GeographicPoint.new(300, 500),
        bottomRightBoundary: Entities::GeographicPoint.new(500, 300)
      )

      province_repository = Repositories::ProvinceRepository.new
      province_repository.clear
      province_repository.insert(bigga_province)
      province_repository.insert(smalla_province)
      province_repository.insert(intersecta_province)
    end

    before do
      post "/properties",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: payload
    end

    context "when the payload is valid" do
      let(payload) do
        <<-JSON
        {
          "x": 400,
          "y": 400,
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
          "x": 400,
          "y": 400,
          "title": "Imóvel código 1, com 5 quartos e 4 banheiros",
          "price": 1250000,
          "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
          "beds": 4,
          "baths": 3,
          "provinces": ["Bigga", "Intersecta"],
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
        expect(response_fields["x"]).to eq(new_property_fields["x"])
        expect(response_fields["y"]).to eq(new_property_fields["y"])
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
          error_message = "Bad Request: {description} missing, {x} missing, {y} missing"
          error_json = {"error" => error_message}.to_json
          expect(response.body).to eq(error_json)
        end
      end

      context "because of validation errors" do
        context "and its title is invalid" do
          let(payload) do
            <<-JSON
            {
              "x": 333,
              "y": 444,
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
              "x": 333,
              "y": 444,
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
              "x": 333,
              "y": 444,
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

        context "and its X-coordinate is invalid" do
          let(payload) do
            <<-JSON
            {
              "x": 1500,
              "y": 444,
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
            error_json = {"error" => "Bad Request: {x} must be between 0 and 1400"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its Y-coordinate is invalid" do
          let(payload) do
            <<-JSON
            {
              "x": 222,
              "y": 1100,
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
            error_json = {"error" => "Bad Request: {y} must be between 0 and 1000"}.to_json
            expect(response.body).to eq(error_json)
          end
        end

        context "and its beds are invalid" do
          let(payload) do
            <<-JSON
            {
              "x": 222,
              "y": 444,
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
              "x": 222,
              "y": 444,
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
              "x": 222,
              "y": 444,
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
