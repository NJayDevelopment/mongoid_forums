module MongoidForums
  class Category
    include Mongoid::Document

    has_many :forums


    field :name
    validates :name, :presence => true
  end
end
