class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember_me user
        redirect_back_or user
      else
        activated_fail
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def login_fail
    flash.now[:danger] = t ".error_login"
    render :new
  end

  def remember_me user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def activated_fail
    flash[:warning] = t ".activated_fail"
    redirect_to root_url
  end
end
