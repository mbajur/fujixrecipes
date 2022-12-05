class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    scope = @user.recipes.order(created_at: :desc).includes([:sensor, :parent, poster_attachment: :blob, user: { avatar_attachment: :blob }])
    @pagy, @recipes = pagy(scope)

    respond_to do |format|
      format.html
      format.turbo_stream { render 'recipes/index' }
    end
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
