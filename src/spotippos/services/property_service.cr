require "../entities/property"
require "../services/province_finder_service"
require "../repositories/property_repository"
require "../entities/geographic_point"

module Spotippos::Services
  class PropertyService
    def initialize(@property_repository : Repositories::PropertyRepository,
                   @province_finder_service : ProvinceFinderService)
    end

    def build(id : Int64 | Nil,
              title : String,
              price : Int64,
              description : String,
              x : Int64,
              y : Int64,
              beds : Int64,
              baths : Int64,
              square_meters : Int64)
      @x = x
      @y = y
      Entities::Property.new(id: id,
        title: title,
        price: price,
        description: description,
        x: @x.as(Int64),
        y: @y.as(Int64),
        beds: beds,
        baths: baths,
        provinces: find_province_names,
        square_meters: square_meters)
    end

    def create(a_property)
      @property_repository.insert(a_property)
    end

    private def find_province_names
      point = Entities::GeographicPoint.new(@x.as(Int64), @y.as(Int64))
      @province_finder_service.in_point(point)
                              .map { |province| province.name }
    end
  end
end
