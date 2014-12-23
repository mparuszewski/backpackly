module Services
  module Geocoordinates
    class Service
      def initialize(opts = {})
        @geocoder_service = opts.fetch(:geocoder_service) { Geocoder }
      end

      def get_geocoordinates(city_name)
        search_results = geocoder_service.search(city_name)
        search_results.first.coordinates
      rescue => e
        Rails.logger.error "#{e.message} (parameters: #{city_name})"
        raise Errors::UnknownLocationError
      end

      private

      attr_reader :geocoder_service
    end
  end
end
