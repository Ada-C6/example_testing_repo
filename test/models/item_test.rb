require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "Item with minimal information is Valid" do
    items(:minimal).valid?
    assert items(:minimal).valid?
  end

  test "Items without name are not valid" do
    assert_not items(:albums_missing_name).valid?
  end

  test "Items with less than 0 votes are invalid" do
    assert_not items(:too_low_rank).valid?
  end

  test "The wrong kinds of items are invalid" do
    assert_not items(:invalid_kind).valid?
  end

  test "upvote should work" do
    assert_difference 'items(:minimal).rank', 1 do
      items(:minimal).upvote
    end
  end

  test "Equivalent? works" do
    assert items(:braveheart_clone).equivalent? items(:braveheart)
    items(:braveheart).name = "Something else"
    assert_not items(:braveheart_clone).equivalent? items(:braveheart)
  end

  test "An item can only be a Book, Movie or Album" do
    item = Item.new(name: "Something", rank: 0, kind: "TV Show")
    assert_not item.valid?
    item.kind = Item::ALBUM_MEDIA
    assert item.valid?
    item.kind = Item::MOVIE_MEDIA
    assert item.valid?
    item.kind = Item::BOOK_MEDIA
    assert item.valid?
  end
end
