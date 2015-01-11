module MongoidForums
  class Permission

    def initialize(user)
      allow "mongoid_forums/admin/forums", [:new]
      allow "mongoid_forums/forums", [:index, :show]

      allow "mongoid_forums/topics", [:show] do |topic|
        (topic.hidden && topic.user_id == user.id) || !topic.hidden
      end

      if user.present?
        allow "mongoid_forums/posts", [:new, :create]
        allow "mongoid_forums/forums", [:new, :create]

        allow "mongoid_forums/topics", [:edit, :update] do |topic|
          topic.user_id == user.id && !topic.locked && !topic.hidden
        end

        allow "mongoid_forums/posts", [:edit, :update] do |post|
          post.user_id == user.id && !post.topic.locked
        end

        #allow_param :topic, [:name, posts: :text]


        rank = Rank.where(:members => user.id).first

        allow_all if rank && rank.admin
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

    def allow_param(resource, attributes)
      @allowed_params ||= {}
      Array(resource).each do |resource|
        @allowed_params[resource.to_s] ||= []
        @allowed_params[resource.to_s] += Array(attributes).map(&:to_s)
      end
    end

    def allow_param?(resource, attribute)
      if @allow_all
        true
      elsif @allowed_params && @allowed_params[resource.to_s]
        @allowed_params[resource.to_s].include? attribute.to_s
      end
    end

    def allow_nested_param(resources, attribute, nested_attributes)
      @allowed_params ||= {}
      Array(resources).each do |resource|
        @allowed_params[resource.to_s] ||= []
        @allowed_params[resource.to_s] += [{ attribute.to_s => Array(nested_attributes).map(&:to_s)}]
      end
    end

    def permit_params!(params)
      if @allow_all
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end

  end
end
