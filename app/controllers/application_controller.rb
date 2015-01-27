class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :login_required
  helper_method :current_user

  def current_user
    if session[:access_provider] == 'redbooth'
      @current_user ||= User.find_by(token: session[:access_token]) if session[:access_token]
    elsif session[:access_provider] == 'trello'
      @current_user ||= User.find_by(trello_token: session[:access_token]) if session[:access_token]
    end
  end

  private

  def login_required
    !current_user.nil? || access_denied
  end

  def access_denied
    redirect_to login_url
  end
end
