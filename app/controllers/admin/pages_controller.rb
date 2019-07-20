class Admin::PagesController < ApplicationController
  layout 'admin'

  def dashboard
    @impressions = Ahoy::Event.order(time: :desc)
  end
end