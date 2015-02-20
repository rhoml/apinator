class ProjectsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project, only: [:edit, :update, :destroy, :swagger, :apisio]

  def index
    @projects = projects.page(params[:page])
  end

  def new
    @project = projects.build
  end

  def create
    @project = projects.build(project_params)
    if @project.save


      uri = URI('http://apis.io/api/apis')
      Net::HTTP.post_form(uri, 'url' => 'https://apinator.herokuapp.com/apisiofake.json')

      redirect_to projects_path, notice: "Project created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to projects_path, notice: "Project updated"
    else
      render 'edit'
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = "Project destroyed"
    end

    redirect_to projects_path
  end

  def apisio
    render json: @project.apisio_spec(request.base_url)
  end

  def swagger
    @url = api_project_swagger_doc_path(project: @project.system_name)
    render layout: "swagger" 
  end

  private

  def find_project
    @project = projects.find(params[:id])
  end

  def projects
    current_user.projects
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
