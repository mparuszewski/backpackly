class AHPBackpackBuilder
  attr_reader :stay_length, :sex

  def initialize(params = {})
    @matrix_builder = AHPCriteriaMatrixBuilder.new(params)
    @stay_length    = params.fetch(:stay_length)
    @sex            = params.fetch(:sex)
  end

  def build
    backpack_name = ahprocess_adapter.decide
    [BackpacksFactory.build("ahp/#{sex}", backpack_name, stay_length)]
  end

  private

  def ahprocess_adapter
    @ahprocess_adapter ||= Ahp::AhpProcessAdapter.new(criteria_matrix: matrix_builder.build)
  end

  attr_reader :matrix_builder
end
