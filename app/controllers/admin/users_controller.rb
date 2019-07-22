class Admin::UsersController < Admin::AdminBaseController
  
  def index
    @page_title  = 'Users'
    @users       = User.order(:created_at).contains(params[:q])
    @users       = @users.page params[:page]

    _track_action()

    @meta_page_title = 'All Users'
  end
end
