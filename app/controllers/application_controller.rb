class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Errorable

  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def authenticate_user!
    return if user_signed_in?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
