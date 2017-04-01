require "../src/spotippos/entities/province"
require "../src/spotippos/entities/geographic_point"
require "../src/spotippos/repositories/province_repository"
require "../src/spotippos/repositories/property_repository"

module Fixtures
  def self.load_fixtures
    load_provinces_into_db
    load_properties_into_db
  end

  private def self.load_provinces_into_db
    provinces = JSON.parse(File.read("fixtures/provinces.json"))

    repository = Spotippos::Repositories::ProvinceRepository.new
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

  private def self.load_properties_into_db
    properties_json = JSON.parse(File.read("fixtures/properties.json"))
    properties = properties_json["properties"]

    property_service = Spotippos::Containers::DomainContainer.default_property_service
    properties.each do |p|
      new_property = property_service.build(
        id: p["id"].as_i64,
        title: p["title"].as_s,
        price: p["price"].as_i64,
        description: p["description"].as_s,
        x: p["lat"].as_i64,
        y: p["long"].as_i64,
        beds: p["beds"].as_i64,
        baths: p["baths"].as_i64,
        square_meters: p["squareMeters"].as_i64
      )
      property_service.create(new_property)
    end
  end
end
