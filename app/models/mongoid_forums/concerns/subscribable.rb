require 'active_support/concern'

module MongoidForums
    module Concerns
        module Subscribable
            extend ActiveSupport::Concern

            included do
                has_many :subscriptions, :as => :subscribable, :class_name => "MongoidForums::Subscription"
            end

            def subscribe_creator
                subscribe_user(self.user_id)
            end

            def subscribe_user(user_id)
                if user_id && !subscriber?(user_id)
                    if sub = subscriptions.where(:subscriber_id => user_id, :unsubscribed => true).first
                        sub.unsubscribed = false
                        sub.save
                    else
                        subscriptions.create(:subscriber_id => user_id)
                    end
                end
            end

            def unsubscribe_user(user_id)
                sub = subscriptions.where(:subscriber_id => user_id).first
                sub.unsubscribed = true
                sub.save
            end

            def subscriber?(user_id)
                subscriptions.where(:subscriber_id => user_id, :unsubscribed => false).count > 0
            end

            def subscription_for user_id
                subscriptions.first(:conditions => { :subscriber_id=>user_id })
            end

            def alert_subscribers(*args)
                subscriptions.where(:unsubscribed => false).each do |sub|
                    sub.alert_subscriber(args)
                end
            end
        end
    end
end
