require "../controller_action"
require "../../validators/search_validator"

module Spotippos::Controllers::Properties
  class IndexAction < ControllerAction
    def call
      params = @env.params.query
      validator = Validators::SearchValidator.new(params)

      if validator.valid?
        property_service = Containers::DomainContainer.default_property_service
        properties = property_service.search(params["ax"].as(String).to_i64,
          params["ay"].as(String).to_i64,
          params["bx"].as(String).to_i64,
          params["by"].as(String).to_i64)

        response = {
          "foundProperties" => properties.size,
          "properties"      => properties,
        }
        response.to_json
      else
        error_message = "Bad Request: #{validator.errors.join(", ")}"
        respond_with_error(@env, 400, error_message)
      end
    end
  end
end
