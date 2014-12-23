module Ahp
  class AhpProcessParameters
    attr_accessor :criteria_attributes, :candidates, :decision_matricies

    def initialize(opts = {})
      @candidates          = opts.fetch(:candidates)
      @criteria_attributes = opts.fetch(:criteria_attributes)
      @decision_matricies  = opts.fetch(:decision_matricies).map { |m| m[:matrix] }
    end

    def self.from_file(file_path)
      AhpProcessParameters.new(YAML::load_file(file_path).deep_symbolize_keys)
    end
  end
end