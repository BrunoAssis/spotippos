module Spotippos::Entities
  class GeographicPoint
    getter :x, :y

    def initialize(@x : Int64, @y : Int64)
    end

    # Crystal's default Integer type is 32-bit, so I'm adding this constructor
    # to make the tests less verbose.
    def self.new(x : Int32, y : Int32)
      new(Int64.new(x), Int64.new(y))
    end
  end
end
