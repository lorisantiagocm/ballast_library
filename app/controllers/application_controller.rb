class ApplicationController < ActionController::Base
  include Pundit::Authorization

  layout :layout_by_resource

  before_action :restrict_admin_access, if: -> { user_signed_in? }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    current_user.librarian? ? admin_dashboard_index_path : member_dashboard_index_path
  end

  private

  def restrict_admin_access
    if request.path.start_with?("/admin") && current_user.member?
      redirect_to root_path, alert: "You do not have access to the admin area."
    end

    if request.path.start_with?("/member") && current_user.librarian?
      redirect_to root_path, alert: "You do not have access to the member area."
    end
  end

  def layout_by_resource
    if user_signed_in?
      "application"
    else
      "signed_out"
    end
  end
end
