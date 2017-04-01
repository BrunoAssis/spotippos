require "../repositories/province_repository"
require "../repositories/property_repository"
require "../services/province_finder_service"
require "../services/property_finder_service"
require "../services/property_service"

module Spotippos::Containers
  class DomainContainer
    def self.default_property_service
      province_repository = Repositories::ProvinceRepository.new
      province_finder_service = Services::ProvinceFinderService.new(province_repository)
      property_repository = Repositories::PropertyRepository.new
      property_finder_service = Services::PropertyFinderService.new(property_repository)

      Services::PropertyService.new(
        property_repository,
        province_finder_service,
        property_finder_service
      )
    end
  end
end
