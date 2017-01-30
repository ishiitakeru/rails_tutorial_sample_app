Rails.application.routes.draw do
  get 'application/hello'
  get 'static_pages/home'

  # get 'static_pages/help'
  get '/help', to: 'static_pages#help'

  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'

  #get 'static_pages/contact'
  # 以下の書き方をすると「_path」「_url」のlink_to指定が有効になる。
  get '/contact', to: 'static_pages#contact'

  get '/login', to: 'static_pages#login'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #root "application#hello"
  root "static_pages#home"
end
