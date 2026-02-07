module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(resource, _opts = {}) # rubocop:disable Metrics/MethodLength
      if resource.persisted?
        render json: {
          user: {
            id: resource.id,
            email: resource.email,
            name: resource.name
          }
        }, status: :created
      else
        render json: {
          error: resource.errors.full_messages.to_sentence
        }, status: :unprocessable_content
      end
    end
  end
end
