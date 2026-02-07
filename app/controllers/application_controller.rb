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
    return if current_user

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def current_user
    @current_user ||= user_from_api_key || user_from_session
  end

  def paginate_headers(scope)
    response.headers['X-Total-Count'] = scope.total_count.to_s
    response.headers['X-Total-Pages'] = scope.total_pages.to_s
    response.headers['X-Current-Page'] = scope.current_page.to_s
  end

  private

  def user_from_api_key
    key = request.headers['X-API-Key']
    return unless key

    User.find_by(api_key: key)
  end

  def user_from_session
    warden.user(:user)
  end
end
