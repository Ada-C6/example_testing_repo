Rails.application.routes.draw do
  root 'homepage#index'

  resources :movies
  resources :books
  resources :albums

  patch '/album/:id/upvote' => 'albums#upvote', as: 'upvote_album'
  patch '/book/:id/upvote' => 'books#upvote', as: 'upvote_book'
  patch '/movie/:id/upvote' => 'movies#upvote', as: 'upvote_movie'
end
