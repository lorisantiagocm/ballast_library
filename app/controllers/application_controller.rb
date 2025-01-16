class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    current_user.librarian? ? admin_dashboard_index_path(current_user) : member_dashboard_index_path(current_user)
  end
end
