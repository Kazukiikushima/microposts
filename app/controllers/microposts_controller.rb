class MicropostsController < ApplicationController
    PER = 10
    before_action :logged_in_user, only: [:create]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed_items.includes(:user).page(params[:page]).per(PER).order(created_at: :desc)
      render 'static_pages/home'
    end
  end
  
  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    return redirect_to root_url if @micropost.nil?
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end
  
  def retweeted
     @micropost = Micropost.find(params[:id])
     current_user.retweeting(@micropost)
     current_user.retwi(@micropost)
     redirect_to root_url
  end
  
  def unretweeted
    @micropost = @micropost = Micropost.find(params[:id])
    current_user.unretweeting(@micropost)
    current_user.unretwi(@micropost)
    redirect_to root_url
  end
  
  def retweet_user
     @micropost = Micropost.find(params[:id])
     @users = @micropost.retweet_users
  end
  
  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
