module Spotippos::Repositories
  class PropertyRepository
    @@storage = {} of Int32 => Entities::Property

    def get(id)
      if @@storage.has_key?(id)
        @@storage[id]
      end
    end

    def insert(a_property)
      key = a_property.id
      @@storage[key] = a_property unless @@storage.has_key?(key)
    end
  end
end
