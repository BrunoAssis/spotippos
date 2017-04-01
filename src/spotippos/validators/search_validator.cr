require "./common_validator"

module Spotippos::Validators
  class SearchValidator < CommonValidator
    protected def validate
      @errors << range_error("ax", 0, 1400)
      @errors << range_error("ay", 0, 1000)
      @errors << range_error("bx", 0, 1400)
      @errors << range_error("by", 0, 1000)
    end
  end
end
