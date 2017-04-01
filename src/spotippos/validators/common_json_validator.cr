module Spotippos::Validators
  class CommonJSONValidator
    def initialize(@payload : JSON::Any)
      @errors = [] of String | Nil
      validate
    end

    def valid?
      !@errors.any?
    end

    def errors
      @errors.compact
    end

    protected def validate; end

    protected def blank_error(fieldname)
      field = @payload[fieldname]?
      return "{#{fieldname}} missing" if field.nil?
      "{#{fieldname}} cannot be blank" if field.as_s.blank?
    end

    protected def greater_error(fieldname, value)
      field = @payload[fieldname]?
      return "{#{fieldname}} missing" if field.nil?
      "{#{fieldname}} must be greater than #{value.to_s}" if field.as_i64 <= value
    end

    protected def range_error(fieldname, min_value, max_value)
      field = @payload[fieldname]?
      return "{#{fieldname}} missing" if field.nil?
      if field.as_i64 < min_value || field.as_i64 > max_value
        "{#{fieldname}} must be between #{min_value.to_s} and #{max_value.to_s}"
      end
    end
  end
end
