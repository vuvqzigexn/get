class Admin::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def authenticate_user!
    redirect_to root_path if !current_user || !current_user.admin?
  end
end
