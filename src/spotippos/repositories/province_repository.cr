module Spotippos::Repositories
  class ProvinceRepository
    @@storage = {} of String => Entities::Province

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
  end
end
