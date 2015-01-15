require "mongoid_forums/engine"

module MongoidForums
  mattr_accessor :per_page, :user_class, :email_from_address
  class << self
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
