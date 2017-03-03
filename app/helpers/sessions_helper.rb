module SessionsHelper
  def session_order
    session[:order] ||= {}
  end

  def valid_admin
    redirect_to root_path if !current_user || current_user.user_type != "admin"
  end
end
