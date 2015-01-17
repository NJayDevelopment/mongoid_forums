=begin

Copyright 2011 Ryan Bigg, Philip Arndt and Josh Adams

This code was obtained from: https://github.com/kultus/forem-2/blob/master/app/models/forem/concerns/viewable.rb

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
    module Viewable
      extend ActiveSupport::Concern

      included do
        field :views_count
        has_many :views, :as => :viewable, :class_name => "MongoidForums::View"
      end

      def view_for(user)
        views.where(:user_id => user.id).first
      end

      # Track when users last viewed topics
      def register_view_by(user)
        return unless user

        view = views.find_or_create_by(:user_id => user.id)
        view.user_id = user.id
        view.inc(count: 1)
        inc(views_count: 1)

        view.past_viewed_at    = view.current_viewed_at
        view.current_viewed_at = Time.now
        view.save
      end
    end
  end
end
