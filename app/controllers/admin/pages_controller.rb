class Admin::PagesController < Admin::AdminBaseController

  def dashboard
    @page_title  = 'Dashboard'
    @impressions = Ahoy::Event.order(time: :desc)
  end
end