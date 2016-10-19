require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: items(:minimal).id
    assert_response :success
  end

  test "Should have flash notice for showing things not in DB" do
    # 1st delete it so it's not in the DB
    id = items(:minimal).id
    delete :destroy, {id: id}
    # 2nd Then try to show the resource
    get :show, id: id
    # You should get redirected and a message that it doesn't exist
    assert_response :redirect
    assert_equal "That item does not exist.", flash[:notice]
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "Should be able to create a new Book" do
    post :create, {item: {name: "The Real Episode VII", author: "G. Lucas", description: "Something better"}}
    assert_response :redirect
  end

  test "Newly created Books should have the right fields and type" do
    post :create, {item: {name: "The Bible", author: "Alla", description: "Something"}}

    album = Item.find_by(name: "The Bible")
    sample_album = Item.new(name: "The Bible", author: "Alla", description: "Something", rank: 0, kind: "Book")

    assert album.equivalent? sample_album
  end

  test "Creating a new Item should change the total number of items" do
    assert_difference 'Item.count', 1 do
      post :create, {item: {name: "The Bible", author: "Alla", description: "Something"}}
    end
  end


  test "should get edit" do
    get :edit, id: items(:minimal).id
    assert_response :success
  end

  test "Trying to edit an item deleted or not there should be redirected" do
      # 1st delete the item
    delete :destroy, id: items(:minimal).id
      # Try to edit the item that's not there.
    get :edit, id: items(:minimal).id
    assert_response :redirect
    assert_equal "That item does not exist.", flash[:notice]
  end

  test "An updated Book should have the right fields" do
    put :update, id: items(:minimal), item: {name: "Something new", author: "Robert J", description: "Something goes here."}

    album = Item.find_by(name: "Something new")
    sample_album = Item.new(name: "Something new", author: "Robert J", description: "Something goes here.", rank: 0, kind: "Book")

    assert album.equivalent? sample_album
  end

  test "Should be able to call destroy" do
    delete :destroy, {id: items(:minimal).id}
    assert_response :redirect
  end

  test "Deleting an item should reduce the total number." do
    assert_difference 'Item.count', -1 do
      delete :destroy, {id: items(:minimal).id}
    end
  end

  test "should be able to upvote an album" do
    patch :upvote, id: items(:minimal)
    assert_response :redirect
  end

  test "Upvoting should increase the rank of an item" do
    assert_difference('Item.find(items(:minimal).id).rank', 1) do
      patch :upvote, id: items(:minimal)
      assert_response :redirect
    end
  end

end
