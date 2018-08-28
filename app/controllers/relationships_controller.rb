class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find_by id: params[:id]
    current_user.follow user
    flash[:success] = t("users.follow.follow ") # << user.name
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    user = Relationship.find_by(params[:id]).followed
    current_user.unfollow user
    flash[:success] = t "users.unfollow.unfollow" # << user.name
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
