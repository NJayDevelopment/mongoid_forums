module MongoidForums
  class Group
    include Mongoid::Document
    
    validates :name, :presence => true

    has_many :memberships
    has_many :members, :through => :memberships, :class_name => MongoidForums.user_class.to_s

    def to_s
      name
    end
  end
end
