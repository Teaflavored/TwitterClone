class UsersController < ApplicationController
  before_action :signed_in_users, only: [:edit, :update, :index, :destroy]
  before_action :signed_in_already, only: [:new, :create]
  before_action :admin_user, only: :destroy
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 8)
  end

  def new
  	@user=User.new
  end

  def destroy
    User.find(params[:id]).destroy unless User.find(params[:id]).admin?
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def show
  	@user=User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
  end

  def create
  	@user=User.new(user_params)
  	if @user.save
  		flash[:success] = "Welcome to My App!"
  		sign_in @user
  		redirect_to @user
   	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

 		def user_params
 			params.require(:user).permit(:name, :email, :password, :password_confirmation)
 		end



    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def signed_in_already
      redirect_to(root_url) if signed_in?
    end
end
