class Admin::UsersController < Admin::AdminBaseController
  
  def index
    @users = User.order(:created_at)
    @users = @users.page params[:page]

    _track_action()

    @meta_page_title = 'All Users'
  end
end
