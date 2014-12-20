class FixedBackpackBuilder
  attr_reader :backpacks_params, :stay_length

  FIXED_BACKPACK_NAMES = [:gadgets, :sports, :glasses].freeze

  def initialize(params = {})
    @stay_length      = params.fetch(:stay_length)
    @backpacks_params = params.slice(*FIXED_BACKPACK_NAMES)
  end

  def build
    backpacks = []
    backpacks_params.each do |type, names|
      names.each { |name| backpacks << BackpacksFactory.build(type, name, stay_length) }
    end
    backpacks
  end
end
