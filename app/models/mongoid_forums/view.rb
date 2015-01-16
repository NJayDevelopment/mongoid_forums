module MongoidForums
  class View
    include Mongoid::Document
    include Mongoid::Timestamps

    field :current_viewed_at, :type => DateTime
    field :past_viewed_at, :type => DateTime

    before_create :set_viewed_at_to_now

    belongs_to :viewable, :polymorphic => true, :index => true
    belongs_to :user, :class_name => MongoidForums.user_class.to_s, :index => true

    validates :viewable_id,   :presence => true
    validates :viewable_type, :presence => true

    #attr_accessible :user, :current_viewed_at, :count
    #field :count, type: Integer

    def viewed_at
      updated_at
    end

    private
    def set_viewed_at_to_now
      self.current_viewed_at = Time.now
      self.past_viewed_at = current_viewed_at
    end
  end
end
