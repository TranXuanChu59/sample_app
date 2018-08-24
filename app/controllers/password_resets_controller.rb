class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_reset_password"
      redirect_to root_path
    else
      flash.now[:danger] = t ".email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".password_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      flash[:error] = t ".password_reset_fail"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:error] = t ".error_email"
    redirect_to root_path
  end

  def valid_user
    unless @user&.activated? &&
           @user.authenticated?(:reset, params[:id])
      flash[:error] = t ".not_activated"
      redirect_to root_path
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".password_reset_has_expired"
    redirect_to new_password_reset_path
  end
end
