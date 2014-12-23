module Services
  module Weather
    class Service
      def initialize(opts = {})
        @geocoordinates_service = opts.fetch(:geocoordinates_service) { Geocoordinates::Service.new }
      end

      def get_forecast(latitude, longitude, date)
        Forecast.from_forecast_io(ForecastIO.forecast(latitude, longitude, time: date.to_i))
      end

      def get_forecast_for_location(location, date)
        latitude, longitude = geocoordinates_service.get_geocoordinates(location)
        get_forecast(latitude, longitude, date)
      rescue => e
        Rails.logger.error "#{e.message} (parameters: #{location}, #{date})"
        raise Errors::UnknownForecastError
      end

      private

      attr_reader :geocoordinates_service
    end
  end
end
