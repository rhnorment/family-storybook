class UsersController < ApplicationController

  before_action     :walled_garden,         only:   [:new, :create]
  before_action     :require_signin,        except: [:new, :create]
  before_action     :require_correct_user,  except: [:new, :create]

  def show
    @page_title = @user.name

    get_user_vars
  end

  def new
    @token = params[:invitation_token]
    @user = User.new

    render layout: 'session'
  end

  def create
    @user = User.new(user_params)
    @token = params[:invitation_token]

    if @user.activate
      sign_in(@user)

      @user.create_relationship_from_invitation(@token) if @token

      redirect_to @user, success: 'Thanks for signing up!'
    else
      render :new, layout: 'session'
    end
  end

  def edit
    @page_title = "Editing #{@user.name}"
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: 'Account successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    if @user.deactivate
      sign_out_user

      redirect_to root_url
    else
      flash.now[:danger] = 'You are not authorized to deactivate this account.'
      render :edit
    end
  end

  private

    def require_correct_user
      @user = User.find(params[:id])

      redirect_to user_url(current_user) unless current_user?(@user)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def get_user_vars
      @storybooks = @user.storybooks.order(created_at: :desc).limit(10)
      @stories = @user.stories.order(created_at: :desc).limit(10)
      @relatives = @user.relatives.order(created_at: :desc).limit(10)
      @activities = Activity.where(owner_id: @user.id).order(created_at: :desc).limit(10)
    end

end
