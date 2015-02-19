class API::SwaggerDocController < ApplicationController
  def show
    render json: Project.last.swagger_doc(request.base_url).as_json
  end
end
