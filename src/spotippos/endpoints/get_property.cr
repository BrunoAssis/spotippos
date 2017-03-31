module Spotippos::Endpoints
  get "/properties/:id" do |env|
    begin
      id = env.params.url["id"].to_i
      repository = Repositories::PropertyRepository.new
      found_property = repository.get(id)
      if found_property
        response = found_property
      else
        env.response.status_code = 404
        env.set "error", "Not Found: Property (#{id}) doesn't exist."
      end
    rescue ArgumentError
      env.response.status_code = 400
      env.set "error", "Bad Request: {id} must be an integer."
    end

    response.to_json
  end
end
