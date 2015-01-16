module MongoidForums
  class Alert
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActionView::Helpers::DateHelper

    field :read, :type => Boolean, :default => false
    field :read_at, :type => DateTime

    # MongoidForums::Topic
    field :mongoid_forums_topic_replier
    field :mongoid_forums_topic_count, :default => 0
    belongs_to :mongoid_forums_topic_post, :class_name => "MongoidForums::Post"

    # Relations
    belongs_to :subscription, :class_name => "MongoidForums::Subscription"
    belongs_to :user, :index => true, :class_name => MongoidForums.user_class.to_s

    def link
      str = ""
      case self.subscription.subscribable_type
      when "MongoidForums::Topic"
        str += "/forums/"
        if self.mongoid_forums_topic_post == nil
          str += "topics/" + self.subscription.subscribable.id.to_s
        else
          str += "posts/" + self.mongoid_forums_topic_post_id.to_s
        end
      else
        str
      end
      str
    end

    def text
      str = ""
      case self.subscription.subscribable_type
      when "MongoidForums::Topic"
        str += self.mongoid_forums_topic_replier
        if self.mongoid_forums_topic_count > 0
          str += " and " + self.mongoid_forums_topic_count.to_s + " other" + (self.mongoid_forums_topic_count > 1 ? "s" : "")
        end
        str += " replied to " + self.subscription.subscribable.subject
      else
        str
      end
      str += " " + time_ago_in_words(self.updated_at, false, :vague => true) + " ago"
    end
  end

end
