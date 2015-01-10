module MongoidForums
  class Forum
    include Mongoid::Document

    belongs_to :category
    has_many :topics

    field :name
    validates :name, :presence => true
  end
end
