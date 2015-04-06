MongoidForums::Engine.routes.draw do

  namespace :admin do
    root :to => 'base#index'
    resources :forums do
      post '/add_group' => 'forums#add_group', as: :add_group
      post '/rem_group' => 'forums#remove_group', as: :rem_group
    end
    resources :categories do
      post '/add_group' => 'categories#add_group', as: :add_group
      post '/rem_group' => 'categories#remove_group', as: :rem_group
    end
    resources :groups do
      post '/add_user' => 'groups#add_member', as: :add_user
      post '/rem_user' => 'groups#remove_member', as: :rem_user
    end

    resources :topics do
      member do
        get 'toggle_hide' => 'topics#toggle_hide', :as => 'toggle_hide'
        get 'toggle_lock' => 'topics#toggle_lock', :as => 'toggle_lock'
        get 'toggle_pin' => 'topics#toggle_pin', :as => 'toggle_pin'
      end
    end

    resources :users do
      post '/add' => 'users#add_admin', as: 'add_admin'
      post '/remove' => 'users#remove_admin', as: 'remove_admin'
    end
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
