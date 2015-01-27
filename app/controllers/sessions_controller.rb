class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
    @providers = Provider.all.to_a
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth['info']['email'])
    if auth['provider'] == 'redbooth'
      user.update(token: auth['credentials']['token'],
                  refresh_token: auth['credentials']['refresh_token'],
                  name: auth['info']['name'])
      session[:access_token] = user.token
    elsif auth['provider'] == 'trello'
      user.update trello_token: auth['credentials']['token'],
                  trello_secret: auth['credentials']['secret']
      session[:access_token] = user.trello_token
    end
    session[:access_provider] = auth['provider']
    redirect_to root_url, notice: 'You are logged in!'
  end

  def destroy
    session[:access_token] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
