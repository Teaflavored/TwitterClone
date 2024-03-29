class RelationshipsController < ApplicationController
  before_action :signed_in_users, only: [:create, :destroy]
  respond_to :html, :js
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_with @user
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
  end
end