class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :sentry_user, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def sentry_user
    Sentry.set_user(
      email: current_user.email,
      username: current_user.username,
      id: current_user.id
    )
  end

  def find_saves(scope)
    user_signed_in? ? Save.where(user: current_user, recipe: scope).map(&:recipe_id) : []
  end
end
