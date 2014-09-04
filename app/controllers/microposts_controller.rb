class MicropostsController < ApplicationController
  before_action :signed_in_users, only: [:create, :destroy]
  before_action :correct_micropost_user, only: :destroy
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost Created!"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = "Micropost Deleted!"
    redirect_to root_url
  end
  
  private
  
    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
    def correct_micropost_user
      @user = Micropost.find(params[:id]).user
      redirect_to current_user unless current_user == @user
    end
end
