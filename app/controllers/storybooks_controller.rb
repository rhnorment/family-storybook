class StorybooksController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_storybook,         only:   [:show,   :edit, :update, :destroy]

  def index
    @page_title = 'My storybooks'
    @storybooks = @user.storybooks.page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @storybooks, status: :ok }
    end
  end

  def show
    @page_title = "Showing: #{@storybook.title}"

    respond_to do |format|
      format.html
      format.json { render json: @storybook, status: :ok }
    end
  end

  def new
    @page_title = 'Start a storybook'
    @storybook = @user.storybooks.new
  end

  def create
    @storybook = @user.storybooks.new(storybook_params)

    if @storybook.save
      redirect_to @storybook, success: 'Your storybook was successfully created!'
    else
      flash.now[:danger] = 'There was a problem creating your storybook.  Please try again.'
      render  :new
    end
  end

  def edit
    @page_title = "Editing #{@storybook.title}"
  end

  def update
    if @storybook.update(storybook_params)
      redirect_to @storybook, success: 'Your storybook was updated.'
    else
      flash.now[:danger] = 'There was a problem updating your storybook.  Please try again.'
      render :edit
    end
  end

  def destroy
    @storybook.destroy

    flash[:warning] = 'Your storybook was successfully removed.'

    redirect_to storybooks_url
  end

  def search
    @storybooks = Storybook.search(params[:query]).records
  end

  private

    def set_correct_user
      @user = current_user

      redirect_to :back unless current_user?(@user)
    end

    def set_storybook
      @storybook = Storybook.find(params[:id])

      redirect_to @user unless @storybook.user == current_user
    end

    def storybook_params
      params.require(:storybook).permit(:title, :description, :cover, story_ids: [])
    end

end
