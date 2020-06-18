Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get 'application/view_config/:id', as: 'view_conf', to: 'application#view_conf', format: false
  post 'application/appli_dwt/:id&:params', as: 'appli_dwt', to: 'application#appli_dwt', format: false
end
