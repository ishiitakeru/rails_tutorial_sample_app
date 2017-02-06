Rails.application.routes.draw do

  get 'application/hello'
  get 'static_pages/home'

  #---------------------------------------------------------
  # 静的ページ
  #---------------------------------------------------------
  # get 'static_pages/help'
  get '/help', to: 'static_pages#help', as: 'help'

  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'

  #get 'static_pages/contact'
  # 以下の書き方をすると「_path」「_url」のlink_to指定が有効になる。
  get '/contact', to: 'static_pages#contact'


  #---------------------------------------------------------
  # ログイン関連
  #---------------------------------------------------------
  # get    'sessions/new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy' #POSTではなくDELETEであるところに注意


  #---------------------------------------------------------
  # ユーザー関連
  #---------------------------------------------------------
  # get 'users/new'
  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # ユーザーテーブルに基づくリソース
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #root "application#hello"
  root "static_pages#home"

end
