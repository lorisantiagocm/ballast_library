module Api
  module V1
    class BaseController < ActionController::API
      include Pundit::Authorization

      before_action :doorkeeper_authorize!

      rescue_from ActiveRecord::RecordNotFound do |_exception|
        head :not_found
      end

      rescue_from Pundit::NotAuthorizedError do |_e|
        head :forbidden
      end

      def render_errors(errors)
        render json: { errors: errors }, status: :bad_request
      end

      def current_user
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
