# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_admin_user, :authenticate_admin_user!

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end

  def authenticate_admin_user!
    redirect_to admin_login_path unless current_admin_user
  end

  def admin_login
    render :admin_login
  end

  def create_admin_session
    admin_user = AdminUser.find_by(email: params[:email])
    if admin_user&.authenticate(params[:password])
      session[:admin_user_id] = admin_user.id
      redirect_to admin_root_path
    else
      flash.now[:alert] = 'Invalid email or password'
      render :admin_login, status: :unprocessable_entity
    end
  end

  def destroy_admin_session
    session[:admin_user_id] = nil
    redirect_to admin_login_path, notice: 'Logged out'
  end
end