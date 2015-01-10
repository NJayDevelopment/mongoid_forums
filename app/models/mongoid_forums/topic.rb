module MongoidForums
  class Topic
    include Mongoid::Document

    belongs_to :category
    has_many :posts

    belongs_to :user, :class_name => "::User"

    field :name
    validates :name, :presence => true
  end
end
