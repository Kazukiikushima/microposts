class RelationshipsController < ApplicationController
    before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
  end

  def destroy
    @user = current_user.following_relationships.find(params[:id]).followed
    current_user.unfollow(@user)
  end
  
  def following_show
    @users = current_user.following_users if logged_in?
  end
  
  def follower_show
    @users = current_user.follower_users if logged_in?
  end
  
end
