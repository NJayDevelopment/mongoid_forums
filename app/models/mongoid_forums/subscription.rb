module MongoidForums
  class Subscription
    include Mongoid::Document
    include Mongoid::Timestamps

    field :unsubscribed, :type => Boolean, :default => false

    belongs_to :subscribable, :polymorphic => true, :index => true
    belongs_to :subscriber, :class_name => MongoidForums.user_class.to_s, :index => true

    validates :subscriber_id, :presence => true
    validates :subscribable_id,   :presence => true
    validates :subscribable_type, :presence => true

    #attr_accessible :subscriber_id

    def alert_subscriber(*args)
      alert = MongoidForums::Alert.where(:subscription_id => self.id, :read => false).first
      puts "ALERTING SUBSCRIBERS WITH"
      puts alert
      case self.subscribable_type
      when "MongoidForums::Topic"
        #return if !allow :read, self.subscribable
        if alert == nil
          last_post = self.subscribable.posts.last
          return if last_post.user.id == self.subscriber_id
          MongoidForums::Alert.create(:subscription_id => self.id, :user_id => self.subscriber_id, :mongoid_forums_topic_post => last_post, :mongoid_forums_topic_replier => last_post.user.forum_display_name)
        else
          alert.updated_at = Time.now
          alert.mongoid_forums_topic_count += 1
          alert.save
        end
      else
        raise TypeError, 'This object is not subscribable!'
      end
    end
  end
end
