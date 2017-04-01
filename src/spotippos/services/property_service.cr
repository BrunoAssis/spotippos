require "../entities/property"
require "../entities/geographic_point"

module Spotippos::Services
  class PropertyService
    def initialize(@province_finder_service : ProvinceFinderService)
    end

    def create(id : Int64 | Nil,
               title : String,
               price : Int64,
               description : String,
               lat : Int64,
               long : Int64,
               beds : Int64,
               baths : Int64,
               square_meters : Int64)
      @lat = lat
      @long = long
      Entities::Property.new(id: id,
        title: title,
        price: price,
        description: description,
        lat: @lat.as(Int64),
        long: @long.as(Int64),
        beds: beds,
        baths: baths,
        provinces: find_province_names,
        square_meters: square_meters)
    end

    private def find_province_names
      point = Entities::GeographicPoint.new(@lat.as(Int64), @long.as(Int64))
      @province_finder_service.in_point(point)
                              .map { |province| province.name }
    end
  end
end
