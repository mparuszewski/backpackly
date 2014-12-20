class Element
  include ActiveModel::Serialization

  attr_accessor :name, :quantity

  def self.from_hash(hash = {}, multiplier = 1)
    Element.new.tap do |element|
      element.name      = hash[:name]
      element.quantity  = hash[:quantity]
      element.quantity *= multiplier if hash[:multiplicable]
    end
  end
end
