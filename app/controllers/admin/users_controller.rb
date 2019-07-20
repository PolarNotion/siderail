class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:created_at)
    @users = @users.page params[:page]
  end
end