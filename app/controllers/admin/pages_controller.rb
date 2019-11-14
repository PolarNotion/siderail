class Admin::PagesController < Admin::AdminBaseController

  def dashboard
    @page_title  = 'Dashboard'
    @impressions = Ahoy::Event.order(time: :desc)
  end

  def utilities
    @page_title  = 'Utilities'
    @impressions = Ahoy::Event.order(time: :desc)
    
    breadcrumb 'Utilities', :utilities_admin_pages_path
  end

  def entries
    @page_title  = 'Entries'
    @impressions = Ahoy::Event.order(time: :desc)
    
    breadcrumb 'Entries', :entries_admin_pages_path
  end
end