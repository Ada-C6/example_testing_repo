require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  [Item::BOOK_MEDIA, Item::ALBUM_MEDIA, Item::MOVIE_MEDIA].each do |media|
    test "should get index for #{ media }" do
      get :index, { media_type: media }
      assert_response :success
    end

    test "should get show for #{ media }" do
      get :show, { id: items((media.downcase + "_sample").to_sym).id, media_type: media }
      assert_response :success
    end

    test "should redirect on show for #{ media } without valid ID" do
      get :show, { id: 99999, media_type: media }
      assert_redirected_to items_path
    end

    test "Should have flash notice for showing things not in DB for #{ media }" do
      # 1st delete it so it's not in the DB
      id = items(:album_sample).id
      delete :destroy, { id: id, media_type: media }

      # 2nd Then try to show the resource
      get :show, { id: id, media_type: media }

      # You should get redirected and a message that it doesn't exist
      assert_response :redirect
      assert_equal ItemsController::EXIST_ERROR, flash[:notice]
    end

    test "should get new for #{ media } " do
      get :new, { media_type: media }
      assert_response :success
    end

    test "Should be able to create a new #{ media } " do
      post :create, {media_type: media, item: {name: "Californication", author: "Lucas", description: "Something"}}
      assert_response :redirect
    end

    test "Should show new form for #{ media } if create fails" do
      post :create, {media_type: media, item: {description: "Bad"}}
      assert_template :new
    end

    test "Newly created #{ media }s should have the right fields and type" do
      post :create, {media_type: media, item: {name: "Californication", author: "Lucas", description: "Something"}}

      found_item = Item.find_by(name: "Californication")
      sample_item = Item.new(name: "Californication", author: "Lucas", description: "Something", rank: 0, kind: media)

      assert found_item.equivalent? sample_item
    end

    test "Creating a new Item should change the total number of items for #{ media }" do
      assert_difference 'Item.count', 1 do
        post :create, { media_type: media, item: {name: "Californication", author: "Lucas", description: "Something"}}
      end
    end

    test "should get edit for #{ media }" do
      get :edit, { id: items(:missing_name).id, media_type: media }
      assert_response :success
    end

    test "should redirect when attempting edit for #{ media } on an item that doesn't exist" do
      get :edit, { id: 999999, media_type: media }
      assert_response :redirect
    end

    test "Trying to edit a #{ media } item deleted or not there should be redirected" do
        # 1st delete the item
      delete :destroy, { id: items(:album_sample).id, media_type: media }
        # Try to edit the item that's not there.
      get :edit, { id: items(:album_sample).id, media_type: media }
      assert_response :redirect
      assert_equal ItemsController::EXIST_ERROR, flash[:notice]
    end

    test "An updated #{ media } should have the right fields" do
      put :update, { id: items(:missing_name), item: {name: "Something new", author: "Bon Jovi", description: "Something goes here."}, media_type: media }

      album = Item.find_by(name: "Something new")
      sample_album = Item.new(name: "Something new", author: "Bon Jovi", description: "Something goes here.", rank: 1, kind: "Album")

      assert album.equivalent? sample_album
    end

    test "Should be able to call destroy a #{ media }" do
      delete :destroy, { id: items(:album_sample).id, media_type: media }
      assert_response :redirect
    end

    test "Should redirect and error when destroying a(n) #{ media } that doesn't exist" do
      delete :destroy, { id: 99999, media_type: media }
      assert_response :redirect
      assert_equal ItemsController::EXIST_ERROR, flash[:notice]
    end

    test "Deleting a(n) #{ media } should reduce the total number." do
      assert_difference 'Item.count', -1 do
        delete :destroy, { id: items(:album_sample).id, media_type: media }
      end
    end

    test "should be able to upvote a(n) #{ media }" do
      patch :upvote, { id: items(:album_sample), media_type: media }
      assert_response :redirect
    end

    test "Upvoting should increase the rank of a(n) #{ media }" do
      assert_difference('Item.find(items(:album_sample).id).rank', 1) do
        patch :upvote, { id: items(:album_sample), media_type: media }
        assert_response :redirect
      end
    end
  end
end
