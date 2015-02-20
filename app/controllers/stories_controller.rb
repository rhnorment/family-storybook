class StoriesController < ApplicationController

  before_action     :require_signin
  before_action     :set_correct_user
  before_action     :set_story,         only:   [:show,   :edit, :update, :destroy]

  def index
    @page_title = 'My stories'
    @stories = @user.stories.page params[:page]
  end

  def show
    @page_title = "Showing: #{@stort.title}"
  end

  def new
    @page_title = 'Create a story'
    @stort = @user.stories.new
  end

  def create
    @story = @user.stories.new(story_params)
    if @story.save
      redirect_to @story, success: 'Your story was successfully created!'
    else
      flash.now[:error] = 'There was a problem creating your story.  Please try again'
      render  :new
    end
  end

  def edit
    @page_title = "Editing #{@story.title}"
  end

  def update
    if @story.update(stor_params)
      redirect_to @story, success: 'Your story was updated.'
    else
      flash.now[:danger] = 'There was a problem updating your story.  Please try again.'
      render :edit
    end
  end

  def destroy
    @story.destroy
    flash[:warning] = 'Your story was successfully removed.'
    redirect_to stories_url
  end

  private

  def set_correct_user
    @user = current_user
    redirect_to :back unless current_user?(@user)
  end

  def set_story
    @story = Story.find(params[:id])
    redirect_to @user unless @story.user == current_user?(@user)
  end

  def story_params
    params.require(:storybook).permit(:title, :content)
  end

end
