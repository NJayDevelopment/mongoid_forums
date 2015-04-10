Rails.application.routes.draw do
  mount MongoidForums::Engine, :at => "/forums"
  devise_for :users
  get 'welcome/index'

  root to: "welcome#index"
end
