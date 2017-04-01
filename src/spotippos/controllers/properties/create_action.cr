require "../controller_action"
require "../../validators/property_payload_validator"

module Spotippos::Controllers::Properties
  class CreateAction < ControllerAction
    def call
      if @env.request.body == nil
        respond_with_error(@env, 400, "Bad Request: Missing payload.")
      else
        payload = JSON.parse(@env.request.body.to_s)
        validator = Validators::PropertyPayloadValidator.new(payload)

        if validator.valid?
          new_property = Entities::Property.new(
            title: payload["title"].as_s,
            price: payload["price"].as_i64,
            description: payload["description"].as_s,
            lat: payload["lat"].as_i64,
            long: payload["long"].as_i64,
            beds: payload["beds"].as_i64,
            baths: payload["baths"].as_i64,
            square_meters: payload["squareMeters"].as_i64)

          repository = Repositories::PropertyRepository.new
          inserted_property = repository.insert(new_property)

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
