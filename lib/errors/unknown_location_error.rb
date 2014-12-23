module Errors
  class UnknownLocationError < BackpacklyError
    def initialize(message = 'given location is unknown or does not exist')
      super(message, 400)
    end
  end
end
