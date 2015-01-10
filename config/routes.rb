MongoidForums::Engine.routes.draw do
  root :to => "forums#index"

  resources :categories, :only => [:index, :show]

  resources :forums do
    resources :topics
  end

  resources :categories

  resources :forums, :only => [:index, :show], :path => "/" do
    resources :topics do
      resources :posts
      member do
        post :subscribe
        post :unsubscribe
      end
    end
  end
end
