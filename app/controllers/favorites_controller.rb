class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:favoed_id])
    current_user.favorite(@micropost)
    redirect_to root_url
  end
  
  def destroy
    # @micropost = Micropost.find(params[:id])
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    # @micropost = current_user.favorite_relationships.find_by(favoed_id: params[:id])
    # current_user.unfavorite(@micropost)
    redirect_to root_url
  end

end
