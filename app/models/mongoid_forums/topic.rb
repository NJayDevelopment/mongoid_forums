module MongoidForums
  class Topic
    include Mongoid::Document
    include Mongoid::Timestamps
    include MongoidForums::Concerns::Subscribable
    include MongoidForums::Concerns::Viewable

    after_create :subscribe_creator

    belongs_to :forum, :class_name => "MongoidForums::Forum"
    has_many :posts, :class_name => "MongoidForums::Post", dependent: :destroy

    belongs_to :user, :class_name => MongoidForums.user_class.to_s

    field :name
    validates :name, :presence => true

    field :locked, type: Boolean, default: false
    field :pinned, type: Boolean, default: false
    field :hidden, type: Boolean, default: false


    def can_be_replied_to?
      !locked?
    end

    def toggle!(field)
      send "#{field}=", !self.send("#{field}?")
      save :validation => false
    end

    def unread_post_count(user)
      view = View.where(:viewable_id => id, :user_id => user.id).first
      return posts.count unless view.present?
      count = 0
      posts.each do |post|
        if post.created_at > view.current_viewed_at
          count+=1
        end
      end
      return count
    end

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
