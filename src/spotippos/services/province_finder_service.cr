require "../repositories/province_repository"

module Spotippos::Services
  class ProvinceFinderService
    def initialize(@province_repository : Repositories::ProvinceRepository)
    end

    def in_point(point)
      @province_repository.all.select { |province| in_bounds?(point, province) }
    end

    private def in_bounds?(point, province)
      province.upperLeftBoundary.x <= point.x &&
        province.bottomRightBoundary.x >= point.x &&
        province.upperLeftBoundary.y >= point.y &&
        province.bottomRightBoundary.y <= point.y
    end
  end
end
