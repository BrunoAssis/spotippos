module Spotippos::Entities
  class Property
    JSON.mapping(
      id: Int32,
      title: String,
      price: Int32,
      description: String,
      lat: Int32,
      long: Int32,
      beds: Int32,
      baths: Int32,
      squareMeters: Int32
    )

    def initialize(@id : Int32,
                   @title : String,
                   @price : Int32,
                   @description : String,
                   @lat : Int32,
                   @long : Int32,
                   @beds : Int32,
                   @baths : Int32,
                   @squareMeters : Int32)
    end
  end
end
