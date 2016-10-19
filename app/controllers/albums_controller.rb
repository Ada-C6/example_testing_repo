class AlbumsController < ApplicationController
  def index
    @all_items = Item.order(rank: :desc).where(kind: ALBUM_MEDIA)
    @media = ALBUM_MEDIA
    @link_path = "/albums/"
    @path = new_album_path
  end

  def show
    @item = Item.find_by(id: params[:id].to_i)

    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    elsif @item.kind != ALBUM_MEDIA
      flash[:notice] = type_error(ALBUM_MEDIA)
      redirect_to action: "index"
    else
      @upvote_path = albums_upvote_path(@item.id)
      @edit_path = edit_album_path(@item.id)
      @delete_path = album_path(@item.id)
      @media = ALBUM_MEDIA.pluralize
      @view_media_path = albums_path
    end

  end

  def new
    @item = Item.new
    @action = :create
    @author_text = ALBUM_AUTHOR
    @method = :post
  end

  def create
    @item = Item.new(post_params(params))
    @item.rank = 0
    @item.kind = ALBUM_MEDIA
    if @item.save
      # success
      redirect_to albums_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    end
    @action = :update
    @author_text = ALBUM_AUTHOR
    @method = :put

  end

  def update
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      redirect_to :index, flash: {notice: EXIST_ERROR }
    end

    if @item.update_attributes(post_params(params))
      redirect_to album_path(@item.id), flash: {notice: "Item saved."}
    else
      redirect_to edit_album_path(@item.id), flash: {notice: "Item could not be saved."}
    end

  end

  def destroy
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    elsif @item.destroy
      flash[:notice] = DELETE_MSG
      redirect_to action: "index", status: 303
    else
      flash[:notice] = "Unable to delete the movie"
      redirect_to action: "index", status: 303
    end
  end

  def upvote
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    else
      @item.upvote
      if request.referer
        redirect_to request.referer
      else
        redirect_to action: "index"
      end
    end
  end

  private

  def post_params(params)
    params.require(:item).permit(:name, :author, :description)
  end
end
