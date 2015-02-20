class API::SwaggerDocController < ApplicationController
  def show
    render json: Project.find_by(system_name: params[:project]).swagger_doc(request.base_url).as_json
  end
end
