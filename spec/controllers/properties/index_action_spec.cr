require "../../spec_helper"

module Spotippos::Controllers::Properties
  Spec2.describe IndexAction do
    before do
      bigga_province = Entities::Province.new(
        name: "Bigga",
        upperLeftBoundary: Entities::GeographicPoint.new(1, 800),
        bottomRightBoundary: Entities::GeographicPoint.new(800, 1)
      )

      intersecta_province = Entities::Province.new(
        name: "Intersecta",
        upperLeftBoundary: Entities::GeographicPoint.new(300, 500),
        bottomRightBoundary: Entities::GeographicPoint.new(500, 300)
      )

      province_repository = Repositories::ProvinceRepository.new
      province_repository.clear

      province_repository.insert(bigga_province)
      province_repository.insert(intersecta_province)

      in_property_1 = Entities::Property.new(
        id: 1,
        title: "Imóvel em Bigga",
        price: 100_000,
        description: "Imóvel em Bigga",
        x: 600,
        y: 600,
        beds: 3,
        baths: 3,
        provinces: ["Bigga"],
        square_meters: 200
      )

      in_property_2 = Entities::Property.new(
        id: 2,
        title: "Imóvel em Intersecta",
        price: 100_000,
        description: "Imóvel em Bigga e Intersecta",
        x: 400,
        y: 400,
        beds: 3,
        baths: 3,
        provinces: ["Bigga", "Intersecta"],
        square_meters: 200
      )

      out_property = Entities::Property.new(
        id: 3,
        title: "Imóvel em Outro Lugar",
        price: 100_000,
        description: "Imóvel em Outro Lugar",
        x: 850,
        y: 850,
        beds: 3,
        baths: 3,
        provinces: [""],
        square_meters: 200
      )

      property_repository = Repositories::PropertyRepository.new
      property_repository.clear
      property_repository.insert(in_property_1)
      property_repository.insert(in_property_2)
      property_repository.insert(out_property)
    end

    before do
      get "/properties?ax=#{ax.to_s}&ay=#{ay.to_s}&bx=#{bx.to_s}&by=#{by.to_s}"
    end

    context "when the parameters are valid" do
      let(response_fields) { JSON.parse(response.body) }

      context "and properties are found" do
        let(ax) { 350 }
        let(ay) { 700 }
        let(bx) { 700 }
        let(by) { 350 }

        it "returns 200 - OK" do
          expect(response.status_code).to eq(200)
        end

        it "returns foundProperties > 0" do
          expect(response_fields["foundProperties"].as_i64).to eq(2)
        end
        it "returns the properties as a JSON" do
          expect(response_fields["properties"][0]["id"].as_i64).to eq(1)
          expect(response_fields["properties"][1]["id"].as_i64).to eq(2)
        end
      end

      context "and properties are not found" do
        let(ax) { 1 }
        let(ay) { 1 }
        let(bx) { 2 }
        let(by) { 2 }

        it "returns foundProperties == 0" do
          expect(response_fields["foundProperties"].as_i64).to eq(0)
        end

        it "returns no properties" do
          expect(response_fields["properties"].size).to eq(0)
        end
      end
    end

    context "when the parameters are invalid" do
      context "because a parameter is missing" do
        let(ax) { nil }
        let(ay) { 100 }
        let(bx) { 100 }
        let(by) { 100 }

        it "returns 400 - Bad Request" do
          expect(response.status_code).to eq(400)
        end

        it "returns an error message" do
          error_json = {"error" => "Bad Request: {ax} missing"}.to_json
          expect(response.body).to eq(error_json)
        end
      end

      context "because a parameter is out of range" do
        let(ax) { 1500 }
        let(ay) { 100 }
        let(bx) { 100 }
        let(by) { 100 }

        it "returns 400 - Bad Request" do
          expect(response.status_code).to eq(400)
        end

        it "returns an error message" do
          error_json = {"error" => "Bad Request: {ax} must be between 0 and 1400"}.to_json
          expect(response.body).to eq(error_json)
        end
      end
    end
  end
end
