Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get 'view_config/:id', as: 'view_conf', to: 'application#view_conf', format: false
  get 'view_dwt/:id', as: 'view_dwt', to: 'application#view_dwt', format: false
  get 'view_dwt_result/:id', as: 'view_dwt_result', to: 'application#view_dwt_result', format: false
  post 'appli_dwt/:id', as: 'appli_dwt', to: 'application#appli_dwt', format: false
end
