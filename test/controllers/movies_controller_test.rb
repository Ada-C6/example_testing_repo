require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: items(:braveheart).id
    assert_response :success
  end

  test "Should have flash notice for showing things not in DB" do
    # 1st delete it so it's not in the DB
    id = items(:braveheart).id
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

  test "Should be able to create a new Movie" do
    post :create, {item: {name: "The Real Episode VII", author: "G. Lucas", description: "Something better"}}
    assert_response :redirect
  end

  test "Newly created Movies should have the right fields and type" do
    post :create, {item: {name: "Stargate", author: "Someone", description: "Something"}}

    album = Item.find_by(name: "Stargate")
    sample_album = Item.new(name: "Stargate", author: "Someone", description: "Something", rank: 0, kind: "Movie")

    assert album.equivalent? sample_album
  end

  test "Creating a new Item should change the total number of items" do
    assert_difference 'Item.count', 1 do
      post :create, {item: {name: "Stargate", author: "Someone", description: "Something"}}
    end
  end


  test "should get edit" do
    get :edit, id: items(:braveheart).id
    assert_response :success
  end

  test "Trying to edit an item deleted or not there should be redirected" do
      # 1st delete the item
    delete :destroy, id: items(:braveheart).id
      # Try to edit the item that's not there.
    get :edit, id: items(:braveheart).id
    assert_response :redirect
    assert_equal "That item does not exist.", flash[:notice]
  end

  test "An updated movie should have the right fields" do
    put :update, id: items(:braveheart), item: {name: "A league of their own", author: "Robert J", description: "Something goes here."}

    album = Item.find_by(name: "A league of their own")
    sample_album = Item.new(name: "A league of their own", author: "Robert J", description: "Something goes here.", rank: 1, kind: "Movie")

    assert album.equivalent? sample_album
  end

  test "Should be able to call destroy" do
    delete :destroy, {id: items(:braveheart).id}
    assert_response :redirect
  end

  test "Deleting an item should reduce the total number." do
    assert_difference 'Item.count', -1 do
      delete :destroy, {id: items(:braveheart).id}
    end
  end

  test "should be able to upvote a movie" do
    patch :upvote, id: items(:braveheart)
    assert_response :redirect
  end

  test "Upvoting should increase the rank of an item" do
    assert_difference('Item.find(items(:braveheart).id).rank', 1) do
      patch :upvote, id: items(:braveheart)
      assert_response :redirect
    end
  end
end
