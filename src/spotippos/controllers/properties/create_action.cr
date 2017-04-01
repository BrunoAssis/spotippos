require "../controller_action"
require "../../validators/property_payload_validator"
require "../../services/province_finder_service"
require "../../repositories/property_repository"
require "../../repositories/province_repository"

module Spotippos::Controllers::Properties
  class CreateAction < ControllerAction
    def call
      if @env.request.body == nil
        respond_with_error(@env, 400, "Bad Request: Missing payload.")
      else
        payload = JSON.parse(@env.request.body.to_s)
        validator = Validators::PropertyPayloadValidator.new(payload)

        if validator.valid?
          lat = payload["lat"].as_i64
          long = payload["long"].as_i64

          province_repository = Repositories::ProvinceRepository.new
          provinces = province_repository.all

          province_finder_service = Services::ProvinceFinderService.new(provinces)
          provinces = province_finder_service.in_point(Entities::GeographicPoint.new(lat, long))
          province_names = provinces.map { |province| province.name }

          new_property = Entities::Property.new(
            id: nil,
            title: payload["title"].as_s,
            price: payload["price"].as_i64,
            description: payload["description"].as_s,
            lat: lat,
            long: long,
            beds: payload["beds"].as_i64,
            baths: payload["baths"].as_i64,
            square_meters: payload["squareMeters"].as_i64,
            provinces: province_names)

          property_repository = Repositories::PropertyRepository.new
          inserted_property = property_repository.insert(new_property)

          @env.response.status_code = 201
          inserted_property.to_json
        else
          error_message = "Bad Request: #{validator.errors.join(", ")}"
          respond_with_error(@env, 400, error_message)
        end
      end
    end
  end
end
