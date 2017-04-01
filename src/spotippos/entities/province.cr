require "./geographic_point"

module Spotippos::Entities
  class Province
    getter :name, :upperLeftBoundary, :bottomRightBoundary

    def initialize(@name : String,
                   @upperLeftBoundary : GeographicPoint,
                   @bottomRightBoundary : GeographicPoint)
    end
  end
end
