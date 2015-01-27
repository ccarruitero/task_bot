class UsersController < ApplicationController
  before_filter :set_user
  before_filter :set_providers, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render action: 'edit'
    end
  end

  private

  def set_user
    @user = @current_user || User.find(params[:id])
  end

  def set_providers
    @providers = Provider.all.to_a
  end

  def user_params
    params.require(:user).permit(:twitter_id, :provider, :project_name)
  end
end
