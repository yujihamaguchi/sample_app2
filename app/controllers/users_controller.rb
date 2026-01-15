class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update index destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in(@user)
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to user_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to user_path(@user)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url, status: :see_other unless current_user.admin?
  end
end
