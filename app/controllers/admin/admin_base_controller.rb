class Admin::AdminBaseController < ApplicationController
  before_action :authenticate_user!
  before_action :_ensure_user_is_admin

  layout 'admin'

  private

  def _ensure_user_is_admin
    unless current_user and current_user.is_admin
      redirect_to root_url
    end
  end
end