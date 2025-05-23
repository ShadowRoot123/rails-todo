Rails.application.routes.draw do
  root "home#index"

  get "pages/home",    as: :pages_home
  get "pages/about",   as: :about      # This defines about_path
  get "pages/contact", as: :contact

  devise_for :users
  get "home/index"
end
