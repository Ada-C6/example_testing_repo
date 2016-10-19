require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: items(:album_sample).id
    assert_response :success
  end

  test "should redirect on show without valid ID" do
    get :show, id: 99999
    assert_redirected_to albums_path
  end

  test "Should have flash notice for showing things not in DB" do
    # 1st delete it so it's not in the DB
    id = items(:album_sample).id
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

  test "Should be able to create a new Album" do
    post :create, {item: {name: "Californication", author: "Lucas", description: "Something"}}
    assert_response :redirect
  end

  test "Should show new form if create fails" do
    post :create, {item: {description: "Bad"}}
    assert_template :new
  end

  test "Newly created Albums should have the right fields and type" do
    post :create, {item: {name: "Californication", author: "Lucas", description: "Something"}}

    album = Item.find_by(name: "Californication")
    sample_album = Item.new(name: "Californication", author: "Lucas", description: "Something", rank: 0, kind: "Album")

    assert album.equivalent? sample_album
  end

  test "Creating a new Item should change the total number of items" do
    assert_difference 'Item.count', 1 do
      post :create, {item: {name: "Californication", author: "Lucas", description: "Something"}}
    end
  end


  test "should get edit" do
    get :edit, id: items(:missing_name).id
    assert_response :success
  end

  test "should redirect when attempting edit on an item that doesn't exist" do
    get :edit, id: 999999
    assert_response :redirect
  end

  test "Trying to edit an item deleted or not there should be redirected" do
      # 1st delete the item
    delete :destroy, id: items(:album_sample).id
      # Try to edit the item that's not there.
    get :edit, id: items(:album_sample).id
    assert_response :redirect
    assert_equal "That item does not exist.", flash[:notice]
  end

  test "An updated Album should have the right fields" do
    put :update, id: items(:missing_name), item: {name: "Something new", author: "Bon Jovi", description: "Something goes here."}

    album = Item.find_by(name: "Something new")
    sample_album = Item.new(name: "Something new", author: "Bon Jovi", description: "Something goes here.", rank: 1, kind: "Album")

    assert album.equivalent? sample_album
  end

  test "Should be able to call destroy" do
    delete :destroy, {id: items(:album_sample).id}
    assert_response :redirect
  end

  test "Should redirect and error when destroying an item that doesn't exist" do
    delete :destroy, id: 99999
    assert_response :redirect
    assert_equal "That item does not exist.", flash[:notice]
  end

  test "Deleting an item should reduce the total number." do
    assert_difference 'Item.count', -1 do
      delete :destroy, {id: items(:album_sample).id}
    end
  end

  test "should be able to upvote an album" do
    patch :upvote, id: items(:album_sample)
    assert_response :redirect
  end

  test "Upvoting should increase the rank of an item" do
    assert_difference('Item.find(items(:album_sample).id).rank', 1) do
      patch :upvote, id: items(:album_sample)
      assert_response :redirect
    end
  end
end
