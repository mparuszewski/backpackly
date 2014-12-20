class Backpack
  include ActiveModel::Serialization

  attr_accessor :name, :type, :elements

  def self.from_hash(hash = {}, multiplier = 1)
    Backpack.new.tap do |backpack|
      backpack.name     = hash[:name]
      backpack.type     = hash[:type]
      backpack.elements = Array.wrap(hash[:elements]).map { |element| Element.from_hash(element, multiplier) }
    end
  end
end
