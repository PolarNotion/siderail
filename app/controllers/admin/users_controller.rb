class Admin::UsersController < Admin::AdminBaseController
  
  def index
    @page_title      = 'Users'
    @meta_page_title = 'All Users'
    @users           = User.order(:created_at).contains(params[:q])
    @users           = @users.page params[:page]

    _track_action()

    breadcrumb 'Users', :admin_users_path
  end
end
