class Admin::PagesController < Admin::AdminBaseController

  def dashboard
    @impressions = Ahoy::Event.order(time: :desc)
  end
end