class ApplicationController < ActionController::Base
  
  private
  
  def _track_action(name='viewed', obj=nil)
    data = obj.present? ? request.path_parameters.merge(type: obj.class.name, id: obj.id) : request.path_parameters

    ahoy.track name, data
  end
end
