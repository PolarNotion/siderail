class PagesController < ApplicationController
  def home
    _track_action()

    @meta_page_title = 'Home'
  end
end
