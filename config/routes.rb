MongoidForums::Engine.routes.draw do

  namespace :admin do
    root :to => 'base#index'
    resources :forums
    resources :categories
  end

  root :to => "forums#index"

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
