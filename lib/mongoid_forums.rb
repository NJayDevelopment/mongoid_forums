require "mongoid_forums/engine"

module MongoidForums
  mattr_accessor :per_page, :user_class, :email_from_address

  class << self
    def per_page
      @@per_page || 20
    end

    def decorate_user_class!
      MongoidForums.user_class.class_eval do

        has_many :mongoid_forums_posts, :class_name => "MongoidForums::Post", :foreign_key => "user_id"
        has_many :mongoid_forums_topics, :class_name => "MongoidForums::Topic", :foreign_key => "user_id"

        # Using +to_s+ by default for backwards compatibility
        def forum_display_name
          to_s
        end unless method_defined? :forum_display_name

      end
    end

    def user_class
      if @@user_class.is_a?(Class)
        raise "You can't set MongoidForums.user_class to be a class. Please use a string instead.\n\n " +
              "See https://github.com/radar/mongoid_forums/issues/88 for more information."
      elsif @@user_class.is_a?(String)
        begin
          Object.const_get(@@user_class)
        rescue NameError
          @@user_class.constantize
        end
      end
    end
  end
end
