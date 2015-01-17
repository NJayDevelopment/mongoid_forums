=begin

Copyright 2011 Ryan Bigg, Philip Arndt and Josh Adams

This code was obtained from: https://github.com/kultus/forem-2/blob/master/app/models/forem/concerns/subscribable.rb

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
