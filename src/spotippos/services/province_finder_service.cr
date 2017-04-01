require "../entities/province"

module Spotippos::Services
  class ProvinceFinderService
    def initialize(@provinces : Array(Entities::Province))
    end

    def in_point(point)
      @provinces.select { |province| in_bounds?(point, province) }
    end

    private def in_bounds?(point, province)
      province.upperLeftBoundary.x < point.x &&
        province.bottomRightBoundary.x > point.x &&
        province.upperLeftBoundary.y > point.y &&
        province.bottomRightBoundary.y < point.y
    end
  end
end
