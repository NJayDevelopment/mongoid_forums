# Fix for #185 and build issues
require 'active_support/core_ext/kernel/singleton_class'
require 'decorators'
require "mongoid_forums/engine"
require 'mongoid_forums/sanitizer'
require 'mongoid_forums/default_permissions'
require 'sanitize'
require 'haml'
require "mongoid"

module MongoidForums
  mattr_accessor :per_page, :user_class, :formatter, :email_from_address, :sign_in_path

  class << self
    def decorate_user_class!
      MongoidForums.user_class.class_eval do
        include MongoidForums::DefaultPermissions

        has_many :mongoid_forums_posts, :class_name => "MongoidForums::Post", :foreign_key => "user_id"
        has_many :mongoid_forums_topics, :class_name => "MongoidForums::Topic", :foreign_key => "user_id"

        field :mongoid_admin, type: Boolean, default: false

        def mongoid_forums_admin?
          mongoid_admin
        end unless method_defined? :mongoid_forums_admin

        # Using +to_s+ by default for backwards compatibility
        def forum_display_name
          to_s
        end unless method_defined? :forum_display_name

      end
    end

    def per_page
      @@per_page || 20
    end

    def user_class
      if @@user_class.is_a?(Class)
        raise "You can't set MongoidForums.user_class to be a class. Please use a string instead.\n\n " +
              "See https://github.com/radar/forem/issues/88 for more information."
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
