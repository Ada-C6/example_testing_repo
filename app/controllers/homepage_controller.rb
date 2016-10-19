class HomepageController < ApplicationController
  def index
    Item.limit(10)
    @movies = Item.where(kind: MOVIE_MEDIA)
    @books  = Item.where(kind: BOOK_MEDIA)
    @albums = Item.where(kind: ALBUM_MEDIA)
  end
end
