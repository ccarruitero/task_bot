class UsersController < ApplicationController
  before_filter :set_user

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

  def user_paramas
    params.require(:user).permit(:twitter_id)
  end
end
