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
