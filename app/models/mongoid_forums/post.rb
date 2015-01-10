module MongoidForums
  class Post
    include Mongoid::Document

    belongs_to :topic

    belongs_to :user, :class_name => "::User"

    belongs_to :reply_to, :class_name => "Post"

    has_many :replies, :class_name  => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    field :text
    validates :text, :presence => true

  end
end
