# app/controllers/admin_sessions_controller.rb
def create
  admin = AdminUser.find_by(email: params[:email])
  if admin&.authenticate(params[:password])
    session[:admin_user_id] = admin.id
    redirect_to admin_root_path
  else
    flash[:alert] = "Invalid email or password"
    render :new
  end
end
