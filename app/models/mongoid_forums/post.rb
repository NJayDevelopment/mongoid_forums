module MongoidForums
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps

    before_save :set_topic_last_post_at

    belongs_to :topic, :class_name => "MongoidForums::Topic"

    belongs_to :user, :class_name => "::User"

    belongs_to :reply_to, :class_name => "MongoidForums::Post"

    has_many :replies, :class_name => "MongoidForums::Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    field :text, type: String
    validates :text, :presence => true

    protected
      def set_topic_last_post_at
        self.topic.update_attribute(:last_post_at, self.created_at)
      end
    end
end
