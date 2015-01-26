=begin

Copyright 2011 Ryan Bigg, Philip Arndt and Josh Adams

This code was obtained from: https://github.com/kultus/forem-2/blob/master/app/models/forem/subscription.rb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


=end

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
