require "../entities/property"

module Spotippos::Repositories
  class PropertyRepository
    @@storage = Hash(Int64, Entities::Property).new

    def get(id)
      if @@storage.has_key?(id)
        @@storage[id]
      end
    end

    def insert(a_property)
      if a_property.id.nil?
        a_property.id = generate_id
      end

      id = a_property.id.as(Int64)
      @@storage[id] = a_property unless @@storage.has_key?(id)
    end

    def all
      @@storage.values
    end

    def clear
      @@storage = Hash(Int64, Entities::Property).new
    end

    # Naively generate an unique id
    private def generate_id
      @@storage.any? ? @@storage.keys.sort.reverse.first + 1 : 1_i64
    end
  end
end
