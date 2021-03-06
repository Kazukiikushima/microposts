class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :followings, :followers, :favorites]
  before_action :logged_in_user, only: [:edit, :update]
  
  def show # 追加
    @user = User.find(params[:id])
    @microposts = @user.microposts.page(params[:page]).per(10).order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # ここを修正
    else
      render 'new'
    end
  end
  
  def edit
    unless session[:user_id] == @user.id
      flash[:danger] = "you did not login this user"
      redirect_to @user
    end
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "プロフィールを編集しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def followings
    @users = @user.following_users
  end
  
  def followers
     @users = @user.follower_users
  end
  
  def favorites
     @microposts = @user.favorite_microposts
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :place, :birthday, :comment,:password,
                                 :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
