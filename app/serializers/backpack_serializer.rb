class BackpackSerializer < ActiveModel::Serializer
  attributes :name

  has_many :elements, serializer: ElementSerializer
end
