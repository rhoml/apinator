class EntitiesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_project
  before_filter :find_entity, only: [:edit, :update, :destroy]

  def index
    @entities = entities.page(params[:page])
  end

  def new
    @entity = entities.build
  end

  def create
    @entity =  entities.build(entity_params)
    process_inputs

    if @entity.save
      redirect_to project_entities_path(@project), notice: 'Entity created'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @entity.attributes = entity_params
    process_inputs
    if @entity.save
      redirect_to project_entities_path, notice: 'Entity updated'
    else
      render 'edit'
    end
  end

  def destroy
    @entity.destroy
    redirect_to project_entities_path, notice: 'Entity destroyed'
  end

  private

  def entities
    @project.entities
  end

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def find_entity
    @entity = entities.find(params[:id])
  end

  def entity_params
    params.require(:entity).permit(:name, :inputs)
  end

  def process_inputs
    inputs = {}
    params[:inputs].each do |hash|
      inputs[hash['name']] = hash['kind'] if hash['name'].present?
    end

    @entity.inputs = inputs
  end
end
