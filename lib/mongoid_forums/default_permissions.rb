module MongoidForums
  # Defines a whole bunch of permissions for mongoid_forums
  # Access (most) areas by default
  module DefaultPermissions
    extend ActiveSupport::Concern

    included do
      unless method_defined?(:can_read_mongoid_forums_category?)
        def can_read_mongoid_forums_category?(category)
          true
        end
      end

      unless method_defined?(:can_read_mongoid_forums_forums?)
        def can_read_mongoid_forums_forums?
          true
        end
      end

      unless method_defined?(:can_read_mongoid_forums_forum?)
        def can_read_mongoid_forums_forum?(forum)
          true
        end
      end

      unless method_defined?(:can_create_mongoid_forums_topics?)
        def can_create_mongoid_forums_topics?(forum)
          true
        end
      end

      unless method_defined?(:can_reply_to_mongoid_forums_topic?)
        def can_reply_to_mongoid_forums_topic?(topic)
          true
        end
      end

      unless method_defined?(:can_edit_mongoid_forums_posts?)
        def can_edit_mongoid_forums_posts?(forum)
          true
        end
      end

      unless method_defined?(:can_destroy_mongoid_forums_posts?)
        def can_destroy_mongoid_forums_posts?(forum)
          true
        end
      end

      unless method_defined?(:can_read_mongoid_forums_topic?)
        def can_read_mongoid_forums_topic?(topic)
          !topic.hidden? || mongoid_forums_admin?
        end
      end

      unless method_defined?(:can_moderate_mongoid_forums_forum?)
        def can_moderate_mongoid_forums_forum?(forum)
          forum.moderator?(self)
        end
      end
    end
  end
end
