class Item < ActiveRecord::Base
  validates :name, presence: true
  validates :rank, numericality: { greater_than_or_equal_to: 0 }
  validates :kind, presence: true

  validate :type_must_be_limited

  AUTHORS = {
    "Book"  => "Author",
    "Movie" => "Director",
    "Album" => "Artist"
  }

  BOOK_MEDIA = "Book"
  MOVIE_MEDIA = "Movie"
  ALBUM_MEDIA = "Album"

  # ALBUM_AUTHOR = "Artist"
  # BOOK_AUTHOR = "Author"
  # MOVIE_AUTHOR = "Director"

  def type_must_be_limited
    if ![BOOK_MEDIA, MOVIE_MEDIA, ALBUM_MEDIA].include?(kind)
      errors.add(:kind, "Must be a Book, Movie or Album")
    end
  end

  def upvote
    self.rank += 1
    self.save
  end

  def equivalent? (other)
    return false if other.class != Item
    return name == other.name && kind == other.kind && rank == other.rank && author == other.author && description == other.description
  end

  def lower_kind
    self.kind.downcase.pluralize
  end
end
