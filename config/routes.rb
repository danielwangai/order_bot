Rails.application.routes.draw do
  get 'telegram/incoming'

  get 'landing/index'

  post 'incoming' => 'telegram#incoming', as: 'incoming'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
