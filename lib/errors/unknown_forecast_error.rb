module Errors
  class UnknownForecastError < BackpacklyError
    def initialize(message = 'forecast service is not possible or forecast does not exist for given location')
      super(message, 503)
    end
  end
end