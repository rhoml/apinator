class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  include SystemName
  has_system_name uniqueness_scope: true

  belongs_to :user
  has_many :entities

  validates :name, presence: true

  def swagger_doc(base_url = "http//localhost:3000")
    hash = {
      apiVersion: "0.1",
      swaggerVersion: "1.2",
      produces: ["application/json"],
      operations: [],
      apis: [
      ],
      info: {},
      basePath: "#{base_url}/api/#{system_name}"
    }

    entities.each do |entity|
      hash[:apis] << { path: "/#{entity.system_name}/swagger_doc", description: entity.name }
    end
    hash
  end


  def apisio_spec(base_url = "http://localhost:3000")
    {
      name: "API #{name}",
      description: "#{name.capitalize} data API",
      url: "#{base_url}",
      image: "#{base_url}/logo.png",
      specificationVersion: "0.14",
      apis: entities.map{|x| x.apisio_spec(base_url)},
       maintainers: [
        {
          FN: "Fullname",
          email: user.email
        }
      ],
      tags: ['data'],
      include: [],
      created: created_at.to_date.to_s(:db),
      modified: updated_at.to_date.to_s(:db)
    }
  end
end
