=begin

Copyright 2011 Ryan Bigg, Philip Arndt and Josh Adams

This code was obtained from: https://github.com/kultus/forem-2/blob/master/app/models/forem/alert.rb

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
