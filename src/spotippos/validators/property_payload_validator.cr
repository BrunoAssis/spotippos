require "./common_json_validator"

module Spotippos::Validators
  class PropertyPayloadValidator < CommonJSONValidator
    protected def validate
      @errors << blank_error("title")
      @errors << blank_error("description")
      @errors << greater_error("price", 0)
      @errors << range_error("x", 0, 1400)
      @errors << range_error("y", 0, 1000)
      @errors << range_error("beds", 1, 5)
      @errors << range_error("baths", 1, 4)
      @errors << range_error("squareMeters", 20, 240)
    end
  end
end
