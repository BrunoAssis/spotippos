module Spotippos::Validators
  class CommonValidator
    def initialize(@properties : JSON::Any |
                                 HTTP::Params |
                                 Hash(String, Int32 | String) |
                                 Hash(String, Int32))
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
      value = @properties[fieldname]?
      return "{#{fieldname}} missing" if value.nil?

      value = value.as_s if value.is_a?(JSON::Any)
      "{#{fieldname}} cannot be blank" if value.to_s.blank?
    end

    protected def greater_error(fieldname, greater_than)
      value = @properties[fieldname]?
      return "{#{fieldname}} missing" if value.nil?

      value = value.as_i64 if value.is_a?(JSON::Any)
      if value.to_i64 <= greater_than
        "{#{fieldname}} must be greater than #{greater_than.to_s}"
      end
    end

    protected def range_error(fieldname, min_value, max_value)
      value = @properties[fieldname]?
      return "{#{fieldname}} missing" if value.nil? || value.to_s.blank?

      value = value.as_i64 if value.is_a?(JSON::Any)
      if value.to_i64 < min_value || value.to_i64 > max_value
        "{#{fieldname}} must be between #{min_value.to_s} and #{max_value.to_s}"
      end
    end
  end
end
