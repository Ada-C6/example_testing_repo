class HomepageController < ApplicationController
  def index
    Item.limit(10)
    @movies = Item.where(kind: Item::MOVIE_MEDIA)
    @books  = Item.where(kind: Item::BOOK_MEDIA)
    @albums = Item.where(kind: Item::ALBUM_MEDIA)
  end
end
