module Spotippos::Entities
  class Property
    JSON.mapping(
      id: Int64 | Nil,
      title: String,
      price: Int64,
      description: String,
      lat: Int64,
      long: Int64,
      beds: Int64,
      baths: Int64,
      provinces: Array(String),
      square_meters: {type: Int64, key: "squareMeters"}
    )

    def initialize(@id : Int64,
                   @title : String,
                   @price : Int64,
                   @description : String,
                   @lat : Int64,
                   @long : Int64,
                   @beds : Int64,
                   @baths : Int64,
                   @provinces : Array(String),
                   @square_meters : Int64)
    end

    def initialize(@title : String,
                   @price : Int64,
                   @description : String,
                   @lat : Int64,
                   @long : Int64,
                   @beds : Int64,
                   @baths : Int64,
                   @square_meters : Int64)
      @id = nil
      @provinces = [] of String
    end

    # Crystal's default Integer type is 32-bit, so I'm adding this constructor
    # to make the tests less verbose.
    def initialize(id : Int32,
                   @title : String,
                   price : Int32,
                   @description : String,
                   lat : Int32,
                   long : Int32,
                   beds : Int32,
                   baths : Int32,
                   @provinces : Array(String),
                   square_meters : Int32)
      @id = Int64.new(id)
      @price = Int64.new(price)
      @lat = Int64.new(lat)
      @long = Int64.new(long)
      @beds = Int64.new(beds)
      @baths = Int64.new(baths)
      @square_meters = Int64.new(square_meters)
    end
  end
end
