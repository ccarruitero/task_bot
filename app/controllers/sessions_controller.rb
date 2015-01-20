class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth['info']['email'])
    user.update(token: auth['credentials']['token'],
                refresh_token: auth['credentials']['refresh_token'],
                name: auth['info']['name'])
    session[:access_token] = user.token
    redirect_to root_url, notice: 'You are logged in!'
  end

  def destroy
    session[:access_token] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
