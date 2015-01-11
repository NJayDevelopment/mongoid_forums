module MongoidForums
  class Permission

    def initialize(user)
      allow "mongoid_forums/admin/forums", [:new]
      allow "mongoid_forums/forums", [:index, :show]
      allow "mongoid_forums/topics", [:show]

      if user.present?
        allow "mongoid_forums/posts", [:new, :create]
        allow "mongoid_forums/forums", [:new, :create]

        allow "mongoid_forums/topics", [:edit, :update] do |topic|
          topic.user_id == user.id
        end

        allow "mongoid_forums/posts", [:edit, :update] do |post|
          post.user_id == user.id
        end

        rank = Rank.where(:members => user.id).first

        allow_all if rank.admin
      end
    end


    def allow?(controller, action, resource = nil)
      puts controller
      puts action
      allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow_all
      @allow_all = true
    end

    def allow(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end
  end
end
