Rails.application.routes.draw do
  root 'homepage#index'
  
  resources :items, { path: ":media_type" } do
    patch '/upvote' => 'items#upvote', on: :member
  end
end
