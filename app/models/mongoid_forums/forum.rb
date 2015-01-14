module MongoidForums
  class Forum
    include Mongoid::Document

    belongs_to :category, :class_name => "MongoidForums::Category"
    has_many :topics, :class_name => "MongoidForums::Topic"

    field :name
    validates :name, :presence => true

    field :order, :type => Integer, :default => 0
  end
end
