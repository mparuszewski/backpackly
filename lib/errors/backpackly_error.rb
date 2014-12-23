module Errors
  class BackpacklyError < StandardError
    include ActiveModel::Serializers::JSON
    attr_reader :code

    def initialize(message, code)
      super(message)
      @code = code
    end

    def attributes
      {
        code: code,
        message: message
      }
    end
  end
end