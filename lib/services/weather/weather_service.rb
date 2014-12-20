module WeatherService
  module_function

  def get_forecast(latitude, longitude, date)
    WeatherForecast.from_forecast_io(ForecastIO.forecast(latitude, longitude, time: date.to_i))
  end
end
