MongoidForums::Engine.routes.draw do

  namespace :admin do
    root :to => 'base#index'
    resources :forums
    resources :categories
  end

  root :to => "forums#index"

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

  # REDIRECT OLD ROUTES
  get '/forums/:forum_id/', :to => "redirect#forum"
  get '/forums/:forum_id/topics/:topic_id', :to => "redirect#topic"
  get '/posts/:post_id', :to => "redirect#posts"
  get '/subscriptions', :to => "redirect#subscriptions"

  resources :categories

end
