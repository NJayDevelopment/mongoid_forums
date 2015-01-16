module MongoidForums
  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps
    include MongoidForums::Concerns::Subscribable
    include MongoidForums::Concerns::Viewable

    after_create :subscribe_creator

    belongs_to :forum, :class_name => "MongoidForums::Forum"
    has_many :posts, :class_name => "MongoidForums::Post"

    belongs_to :user, :class_name => MongoidForums.user_class.to_s

    field :name
    validates :name, :presence => true

    field :locked, type: Boolean, default: false
    field :pinned, type: Boolean, default: false
    field :hidden, type: Boolean, default: false

    class << self
      def by_most_recent_post
        order_by([:last_post_at, :desc])
      end

      def by_pinned_or_most_recent_post
        order_by([:pinned, :desc], [:last_post_at, :desc])
      end
    end
  end
end
