module MongoidForums
  class Rank
    include Mongoid::Document

    field :members, type: Array, default: []
    field :admin,     type: Boolean, default: false

  end
end
