require "../repositories/property_repository"

module Spotippos::Services
  class PropertyFinderService
    def initialize(@property_repository : Repositories::PropertyRepository)
    end

    def in_area(upperLeftPoint, bottomRightPoint)
      @property_repository.all.select do |a_property|
        in_bounds?(upperLeftPoint,
          bottomRightPoint,
          a_property)
      end
    end

    private def in_bounds?(upperLeftPoint, bottomRightPoint, a_property)
      a_property.x >= upperLeftPoint.x &&
        a_property.x <= bottomRightPoint.x &&
        a_property.y <= upperLeftPoint.y &&
        a_property.y >= bottomRightPoint.y
    end
  end
end
