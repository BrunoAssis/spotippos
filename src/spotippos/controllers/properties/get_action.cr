require "../controller_action"

module Spotippos::Controllers::Properties
  class GetAction < ControllerAction
    def call
      begin
        id = @env.params.url["id"].to_i
      rescue ArgumentError
        respond_with_error(@env, 400, "Bad Request: {id} must be an integer.")
      end

      repository = Repositories::PropertyRepository.new
      found_property = repository.get(id)
      if found_property
        response = found_property
      else
        respond_with_error(@env, 404, "Not Found: Property (#{id}) doesn't exist.")
      end

      response.to_json
    end
  end
end
