module MongoidForums
  class Category
    include Mongoid::Document

    has_many :forums, :class_name => "MongoidForums::Forum"


    field :name
    validates :name, :presence => true
  end
end
