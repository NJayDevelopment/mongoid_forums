MongoidForums::Engine.routes.draw do
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
