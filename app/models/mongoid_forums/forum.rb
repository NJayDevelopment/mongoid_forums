module MongoidForums
  class Forum
    include Mongoid::Document
    include MongoidForums::Concerns::Viewable

    belongs_to :category, :class_name => "MongoidForums::Category"
    has_many :topics, :class_name => "MongoidForums::Topic"

    # Caching
    field :posts_count, :type => Integer

    field :name
    validates :name, :presence => true

    field :order, :type => Integer, :default => 0

    def count_of_posts
      topics.inject(0) {|sum, topic| topic.posts.count + sum }
    end

    def increment_posts_count
      if self.posts_count == nil
        self.posts_count = 1
      else
        self.posts_count += 1
      end
      self.save
    end
  end
end
