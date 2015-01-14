require "mongoid_forums/engine"

module MongoidForums
  mattr_accessor :per_page
  class << self
    def per_page
      @@per_page || 20
    end
  end
end
