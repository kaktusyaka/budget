class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :authenticate_user!
  around_filter :set_time_zone, if: :current_user
  protect_from_forgery with: :exception
  layout :layout_by_resource

  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end


  def set_time_zone
    time_zone = current_user.try(:time_zone) || 'UTC'
    Time.use_zone(time_zone) { yield }
  end
end
