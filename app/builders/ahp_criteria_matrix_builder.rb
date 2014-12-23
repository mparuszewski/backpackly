class AHPCriteriaMatrixBuilder
  attr_reader :place, :date, :accommodation, :reason

  AHP_MAX_CRITERIA_WEIGHT = 9

  def initialize(params = {})
    @weather_service = params.fetch(:weather_service) { Services::Weather::Service.new }

    @place         = params.fetch(:place)
    @date          = params.fetch(:date)
    @stay_length   = params.fetch(:stay_length)

    @accommodation = params.fetch(:accommodation)
    @reason        = params.fetch(:reason)
  end

  def build
    criteria = [comfort_weight, heat_weight, elegance_weight, precipitation_weight]
    build_matrix(criteria)
  end

  private

  attr_reader :weather_service

  def weather
    @weather ||= weather_service.get_forecast_for_location(place, date)
  end

  def build_matrix(criteria)
    normalized_criteria = ((Vector[*criteria] / Vector[*criteria].max) * AHP_MAX_CRITERIA_WEIGHT)
    matrix = []
    (0...criteria.length).each do |i|
      matrix[i] = []
      (0...criteria.length).each do |j|
        matrix[i][j] = normalized_criteria[j].to_f / normalized_criteria[i]
      end
    end

    matrix
  end

  def comfort_weight
    case accommodation
    when 'hotel'         then 8.0
    when 'hostel'        then 7.0
    when 'friends_house' then 5.0
    when 'rental'        then 3.0
    when 'tent'          then 1.0
    end
  end

  def heat_weight
    case weather.temperature
    when :freezing then 8.0
    when :cold     then 7.0
    when :cool     then 6.0
    when :warm     then 5.0
    when :hot      then 2.0
    end
  end

  def elegance_weight
    case reason
    when 'business'   then 9.0
    when 'date'       then 8.0
    when 'conference' then 7.0
    when 'vacation'   then 6.0
    end
  end

  def precipitation_weight
    case weather.precip_type
    when :snow then 7.0
    when :rain then 5.0
    when :none then 1.0
    end
  end
end
