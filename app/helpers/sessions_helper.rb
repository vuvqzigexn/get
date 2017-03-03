module SessionsHelper
  def session_order
    session[:order] ||= {}
  end
end
