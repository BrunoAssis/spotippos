module Spotippos::Entities
  class Property
    JSON.mapping(
      id: Int64 | Nil,
      title: String,
      price: Int64,
      description: String,
      x: Int64,
      y: Int64,
      beds: Int64,
      baths: Int64,
      provinces: Array(String),
      square_meters: {type: Int64, key: "squareMeters"}
    )

    def initialize(@id : Int64 | Nil,
                   @title : String,
                   @price : Int64,
                   @description : String,
                   @x : Int64,
                   @y : Int64,
                   @beds : Int64,
                   @baths : Int64,
                   @provinces : Array(String),
                   @square_meters : Int64)
    end

    # Crystal's default Integer type is 32-bit, so I'm adding this constructor
    # to make the tests less verbose.
    def self.new(id : Int32,
                 title : String,
                 price : Int32,
                 description : String,
                 x : Int32,
                 y : Int32,
                 beds : Int32,
                 baths : Int32,
                 provinces : Array(String),
                 square_meters : Int32)
      new(Int64.new(id),
        title,
        Int64.new(price),
        description,
        Int64.new(x),
        Int64.new(y),
        Int64.new(beds),
        Int64.new(baths),
        provinces,
        Int64.new(square_meters))
    end
  end
end
