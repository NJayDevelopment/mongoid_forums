module MongoidForums
  class Group
    include Mongoid::Document

    validates :name, :presence => true

    field :name, type: String
    field :members, type: Array, default: []

    def to_s
      name
    end
  end
end
