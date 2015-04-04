module MongoidForums
  class Category
    include Mongoid::Document

    has_many :forums, :class_name => "MongoidForums::Forum",  dependent: :destroy
    has_and_belongs_to_many :moderator_groups, :class_name => "MongoidForums::Group", inverse_of: nil


    field :name
    validates :name, :presence => true

    field :order, :type => Integer, :default => 0
  end
end
