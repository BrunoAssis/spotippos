require "../entities/property"
require "../services/province_finder_service"
require "../services/property_finder_service"
require "../repositories/property_repository"
require "../entities/geographic_point"

module Spotippos::Services
  class PropertyService
    def initialize(@property_repository : Repositories::PropertyRepository,
                   @province_finder_service : ProvinceFinderService,
                   @property_finder_service : PropertyFinderService)
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
      Entities::Property.new(id: id,
        title: title,
        price: price,
        description: description,
        x: x,
        y: y,
        beds: beds,
        baths: baths,
        provinces: find_province_names(x, y),
        square_meters: square_meters)
    end

    def create(a_property)
      @property_repository.insert(a_property)
    end

    def search(ax, ay, bx, by)
      upperLeftPoint = Entities::GeographicPoint.new(ax, ay)
      bottomRightPoint = Entities::GeographicPoint.new(bx, by)
      @property_finder_service.in_area(upperLeftPoint, bottomRightPoint)
    end

    private def find_province_names(x, y)
      point = Entities::GeographicPoint.new(x, y)
      @province_finder_service.in_point(point)
                              .map { |province| province.name }
    end
  end
end
