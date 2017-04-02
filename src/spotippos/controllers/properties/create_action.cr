require "../controller_action"
require "../../containers/domain_container"
require "../../validators/property_payload_validator"
require "../../repositories/property_repository"

module Spotippos::Controllers::Properties
  class CreateAction < ControllerAction
    def call
      begin
        body = @env.request.body.as(IO).gets_to_end
      rescue TypeCastError
        respond_with_error(@env, 400, "Bad Request: Missing payload.")
      end

      body = body.as(String)
      if body.blank?
        respond_with_error(@env, 400, "Bad Request: Missing payload.")
      else
        payload = JSON.parse(body)
        validator = Validators::PropertyPayloadValidator.new(payload)

        if validator.valid?
          property_service = Containers::DomainContainer.default_property_service

          new_property = property_service.build(
            id: nil,
            title: payload["title"].as_s,
            price: payload["price"].as_i64,
            description: payload["description"].as_s,
            x: payload["x"].as_i64,
            y: payload["y"].as_i64,
            beds: payload["beds"].as_i64,
            baths: payload["baths"].as_i64,
            square_meters: payload["squareMeters"].as_i64)

          created_property = property_service.create(new_property)

          @env.response.status_code = 201
          created_property.to_json
        else
          error_message = "Bad Request: #{validator.errors.join(", ")}"
          respond_with_error(@env, 400, error_message)
        end
      end
    end
  end
end
