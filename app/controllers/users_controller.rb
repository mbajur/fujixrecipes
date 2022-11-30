class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    @recipes = @user.recipes
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :display_name, :avatar, :bio, :website)
  end
end
