class WeatherForecast
  attr_accessor :precip_type, :temperature, :wind

  def self.from_forecast_io(params)
    currently_forecast = params.currently
    WeatherForecast.new.tap do |forecast|
      forecast.precip_type = map_precip_type(currently_forecast.percipType)
      forecast.temperature = map_temperature(currently_forecast.apparentTemperature)
    end
  end

  private

  def self.map_precip_type(data)
    case data
    when 'rain'                  then :rain
    when 'snow', 'sleet', 'hail' then :snow
    else                              :none
    end
  end

  def self.map_temperature(data)
    case data
    when -200...32 then :freezing
    when 32...50   then :cold
    when 50...68   then :cool
    when 68...86   then :warm
    else                :hot
    end
  end
end