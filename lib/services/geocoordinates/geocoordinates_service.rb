module GeocoordinatesService
  module_function

  def get_geocoordinates(city_name)
    search_results = Geocoder.search(city_name)
    search_results.first.coordinates
  end
end
