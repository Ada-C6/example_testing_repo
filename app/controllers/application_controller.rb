class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Media Types
  ALBUM_MEDIA = "Album"
  BOOK_MEDIA = "Book"
  MOVIE_MEDIA = "Movie"

  ALBUM_AUTHOR = "Artist"
  BOOK_AUTHOR = "Author"
  MOVIE_AUTHOR = "Director"

  # User messages
  EXIST_ERROR = "That item does not exist."
  DELETE_MSG = "Sucessfully deleted"

  def type_error(item_type)
    "That item is not a #{ item_type.lowercase }."
  end
end
