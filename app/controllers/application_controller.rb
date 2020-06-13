class ApplicationController < ActionController::Base
  def index
  end
  def view_conf
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end
end
