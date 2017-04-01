require "../repositories/province_repository"
require "../services/province_finder_service"
require "../services/property_service"

module Spotippos::Containers
  class DomainContainer
    def self.default_property_service
      provinces = Repositories::ProvinceRepository.new.all
      province_finder_service = Services::ProvinceFinderService.new(provinces)
      Services::PropertyService.new(
        Spotippos::Repositories::PropertyRepository.new,
        province_finder_service
      )
    end
  end
end
