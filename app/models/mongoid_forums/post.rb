module MongoidForums
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :topic, :class_name => "MongoidForums::Topic"

    belongs_to :user, :class_name => "::User"

    belongs_to :reply_to, :class_name => "MongoidForums::Post"

    has_many :replies, :class_name => "MongoidForums::Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    field :text, type: String
    validates :text, :presence => true

  end
end
