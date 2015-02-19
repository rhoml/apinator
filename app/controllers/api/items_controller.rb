class API::ItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  respond_to :json

  before_filter :find_project
  before_filter :find_entity
  before_filter :find_item, only: [:show, :update, :destroy]

  def index
    @items = @entity.items.page(params[:page]).per(params[:per]||50)
    respond_with(@items, attributes)
  end

  def show
    respond_with(@item, attributes)
  end

  def create
    @item = items.build
    save_and_respond
  end

  def update
    save_and_respond
  end

  def destroy
    @item.destroy
    respond_with(@item, attributes)
  end


  private

  def save_and_respond
    @item.assing_params(params)
    @item.save
    respond_with(@item, attributes)
  end

  def find_item
    @item = items.find(params[:id])
  end

  def items
    @entity.items
  end

  def item_url(item)
    api_item_path(item, project: @project.system_name, entity: @entity.system_name)
  end

  def attributes
    {except: [:entity_id, :_id], methods: [:id]}
  end

  def find_project
    @project = Project.find_by(system_name: params[:project])
  end

  def find_entity
    @entity = @project.entities.find_by(system_name: params[:entity])
  end
end
