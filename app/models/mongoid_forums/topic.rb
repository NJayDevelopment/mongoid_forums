module MongoidForums
  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :forum, :class_name => "MongoidForums::Forum"
    has_many :posts, :class_name => "MongoidForums::Post"

    belongs_to :user, :class_name => "::User"

    field :name
    validates :name, :presence => true
  end
end
