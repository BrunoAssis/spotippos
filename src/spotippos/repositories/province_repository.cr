module Spotippos::Repositories
  class ProvinceRepository
    @@storage = Hash(String, Entities::Province).new

    def get(name)
      if @@storage.has_key?(name)
        @@storage[name]
      end
    end

    def insert(province)
      name = province.name
      @@storage[name] = province unless @@storage.has_key?(name)
    end

    def all
      @@storage.values
    end

    def clear
      @@storage = Hash(String, Entities::Province).new
    end
  end
end
