MongoidForums::Engine.routes.draw do

  namespace :admin do
  get 'groups/index'
  end

  namespace :admin do
  get 'groups/new'
  end

  namespace :admin do
  get 'groups/create'
  end

  namespace :admin do
  get 'groups/edit'
  end

  namespace :admin do
  get 'groups/update'
  end

  namespace :admin do
  get 'groups/show'
  end

  namespace :admin do
  get 'groups/destroy'
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/index'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/new'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/create'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/edit'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/update'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/show'
    end
  end

  namespace :mongoid_forums do
  namespace :admin do
    get 'groups/destroy'
    end
  end

  namespace :admin do
    root :to => 'base#index'
    resources :forums
    resources :categories
  end

  root :to => "forums#index"

  # REDIRECT OLD ROUTES
  get '/forums/:forum_id/', :to => "redirect#forum"
  get '/forums/:forum_id/topics/:topic_id', :to => "redirect#topic"
  get '/posts/:post_id', :to => "redirect#posts"
  get '/subscriptions', :to => "redirect#subscriptions"


  # ME ROUTES
  get 'my_subscriptions', :to => "topics#my_subscriptions"
  get 'my_topics', :to => "topics#my_topics"
  get 'my_posts', :to => "topics#my_posts"

  # this moves the creation of topics into /forum_id/new
  resources :forums, :path => "/" do
    get 'new'
    post 'create'
  end

  resources :topics, :path => "/topics" do
    resources :posts
    member do
      get :subscribe
      get :unsubscribe
    end
  end


  resources :categories

end
