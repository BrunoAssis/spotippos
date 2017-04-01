require "kemal"

require "./spotippos/version"
require "./spotippos/endpoints"

before_all do |env|
  env.response.content_type = "application/json; charset=utf-8"
end

def respond_with_error(env, status_code, error_message)
  env.response.status_code = status_code
  env.response.print({"error" => error_message}.to_json)
  env.response.close
end

require "./spotippos/entities/property"
require "./spotippos/entities/province"
require "./spotippos/entities/geographic_point"
require "./spotippos/repositories/province_repository"
require "./spotippos/repositories/property_repository"

def load_provinces_into_db
  repository = Spotippos::Repositories::ProvinceRepository.new
  provinces = JSON.parse(File.read("fixtures/provinces.json"))

  provinces.each do |name, attributes|
    boundaries = attributes["boundaries"]
    upperLeft = boundaries["upperLeft"]
    bottomRight = boundaries["bottomRight"]
    geoPointUL = Spotippos::Entities::GeographicPoint.new(upperLeft["x"].as_i64, upperLeft["y"].as_i64)
    geoPointBR = Spotippos::Entities::GeographicPoint.new(bottomRight["x"].as_i64, bottomRight["y"].as_i64)

    new_province = Spotippos::Entities::Province.new(name.as_s, geoPointUL, geoPointBR)
    repository.insert(new_province)
  end
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

load_provinces_into_db unless ENV["KEMAL_ENV"] == "test"
load_properties_into_db unless ENV["KEMAL_ENV"] == "test"

Kemal.run
