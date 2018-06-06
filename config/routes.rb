Rails.application.routes.draw do
  root 'welcome#index'
  resources :widgets
  #resources :webhooks, only: :create # for LINE webhook
  namespace :recommended_movies do
    resources :inquiries, only: :create
  end
end
