module MongoidForums
  class Category
    include Mongoid::Document

    has_many :forums, :class_name => "MongoidForums::Forum",  dependent: :destroy
    has_and_belongs_to_many :moderator_groups, :class_name => "MongoidForums::Group", inverse_of: nil


    field :name
    validates :name, :presence => true

    field :position, :type => Integer, :default => 0
    validates :position, numericality: { only_integer: true }

    def moderator?(user)
      return false unless user
      moderator_groups.each do |group|
        return true if group.moderator && group.members.include?(user.id)
      end
      false
    end

    def moderators
      array = Array.new
      self.moderator_groups.each do |g|
        array << g.group.members
      end
      return array
    end
  end
end
