class BooksController < ApplicationController
  def index
    @all_items = Item.order(rank: :desc).where(kind: "Book")
    @media = Item::BOOK_MEDIA
  end

  def show
    @item = Item.find_by(id: params[:id].to_i)

    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    end
  end

  def new
    @item = Item.new
    @author_text = Item::BOOK_AUTHOR
  end

  def create
    @item = Item.new(post_params(params))
    @item.rank = 0
    @item.kind = Item::BOOK_MEDIA
    if @item.save
      # success
      redirect_to books_path
    else
      render :new
    end
  end

  def edit
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to action: "index"
    elsif @item.kind != Item::BOOK_MEDIA
      flash[:notice] = type_error(Item::BOOK_MEDIA)
      redirect_to action: "index"
    end
    @author_text = Item::BOOK_AUTHOR
  end

  def update
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      redirect_to :index, flash: {notice: EXIST_ERROR }
    elsif @item.kind != Item::BOOK_MEDIA
      redirect_to :index, flash: { notice: type_error(Item::BOOK_MEDIA) }
    end

    if @item.update_attributes(post_params(params))
      redirect_to book_path(@item.id), flash: {notice: "Item saved."}
    else
      redirect_to edit_book_path(@item.id), flash: {notice: "Item could not be saved."}
    end
  end

  def destroy
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to :index
    elsif @item.kind != Item::BOOK_MEDIA
      flash[:notice] = type_error(Item::BOOK_MEDIA)
      redirect_to :index
    elsif @item.destroy
      flash[:notice] = DELETE_MSG
      redirect_to :action=> :index, status: 303
    else
      flash[:notice] = "Unable to delete the book"
      redirect_to :action=> :index, status: 303
    end
  end

  def upvote
    @item = Item.find_by(id: params[:id].to_i)
    if @item == nil # if the item does not exist
      flash[:notice] = EXIST_ERROR
      redirect_to :index
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
