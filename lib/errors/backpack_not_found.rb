module Errors
  class BackpackNotFound < BackpacklyError
    def initialize(message)
      super(message, 404)
    end
  end
end