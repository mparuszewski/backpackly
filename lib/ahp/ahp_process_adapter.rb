module Ahp
  class AhpProcessAdapter
    def initialize(opts = {})
      @ahp_process_engine = opts.fetch(:engine) { AHProcess }
      @criteria_matrix = opts.fetch(:criteria_matrix)
    end

    def decide
      decission = ahp_process_engine.decide(ahprocess_parameters.decision_matricies, criteria_matrix, ahprocess_parameters.candidates.length)
      ahprocess_parameters.candidates[decission.each_with_index.max.last]
    end

    private

    attr_reader :criteria_matrix, :ahp_process_engine

    def ahprocess_parameters
      @ahprocess_parameters ||= AhpProcessParameters.from_file(Rails.root.join('lib', 'backpacks', 'ahp', 'decision_matricies.yml'))
    end
  end
end
