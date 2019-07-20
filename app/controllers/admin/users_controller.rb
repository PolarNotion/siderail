class Admin::UsersController < ApplicationController
  layout 'admin'
  
  def index
    @users = User.order(:created_at)
    @users = @users.page params[:page]

    @meta_page_title = 'All Users'
  end
end
