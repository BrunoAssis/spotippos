require "kemal"
require "./spotippos/version"
require "./spotippos/endpoints/*"
require "./spotippos/entities/*"
require "./spotippos/repositories/*"

before_all do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

def respond_with_error(env, status_code, error_message)
  env.response.status_code = status_code
  env.response.print({"error" => error_message}.to_json)
  env.response.close
end

def load_properties_into_db
  repository = Spotippos::Repositories::PropertyRepository.new
  properties_json = JSON.parse(File.read("fixtures/properties.json"))
  properties = properties_json["properties"]

  properties.each do |p|
    new_property = Spotippos::Entities::Property.from_json(p.to_json)
    repository.insert(new_property)
  end
end

load_properties_into_db

Kemal.run
