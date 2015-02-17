class StorybooksController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_storybook,         only:   [:show,   :edit, :update, :destroy]

  def index
    @page_title = 'My storybook'
    @storybooks = @user.storybooks
  end

  def show
    @page_title = "Showing storybook: #{@storybook.title}"
  end

  def new
    @page_title = 'Create a new storybook'
    @storybook = @user.storybooks.new
  end

  def create
    @storybook = @user.storybooks.new(storybook_params)
    if @storybook.save
      redirect_to storybooks_url, success: 'Your storybook was successfully created!'
    else
      flash.now[:error] = 'There was a problem creating your storybook.  Please try again'
      render  :new
    end
  end

  def edit
    @page_title = "Editing #{@storybook.title}"
  end

  def update
    if @storybook.update(storybook_params)
      redirect_to storybooks_url, success: 'Your storybook was updated.'
    else
      flash.now[:error] = 'There was a problem updating your storybook.  Please try again.'
      render :edit
    end
  end

  def destroy
    @storybook.destroy
    flash[:warning] = 'Your storybook was successfully removed.'
    redirect_to storybooks_url
  end

  private

    def set_correct_user
      @user = current_user
      redirect_to :back unless current_user?(@user)
    end

    def set_storybook
      @storybook = Storybook.find(params[:id])
    end

    def storybook_params
      params.require(:storybook).permit(:title, :description, :cover)
    end

end
