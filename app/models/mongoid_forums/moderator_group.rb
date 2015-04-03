module MongoidForums
  class ModeratorGroup
    include Mongoid::Document

    belongs_to :forum, :inverse_of => :moderator_groups, :class_name => "MongoidForums::Forum"
    belongs_to :group, :class_name => "MongoidForums::Group"

    #attr_accessible :group_id
  end
end
