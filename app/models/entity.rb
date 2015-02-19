class Entity
  include Mongoid::Document
  include Mongoid::Timestamps

  KINDS = [NUMBER = :number, STRING = :string, DATETIME = :datetime]

  include SystemName
  has_system_name uniqueness_scope: true

  field :inputs, type: Hash, default: {title: STRING}

  belongs_to :project
  has_many :items


  def keys
    inputs.keys
  end

  def path
    "/#{self.name}"
  end

  def swagger_doc(base_url = "http//localhost:3000")
    hash = {
      apiVersion: "0.1",
      swaggerVersion: "1.2",
      produces: ["application/json"],
      apis: [
        {
          path: "/#{system_name}",
          operations: [
            {
              method: "GET",
              summary: "List #{name}",
              nickname: "list_#{system_name}"
            },
            {
              method: "POST",
              summary: "Create #{name}",
              nickname: "create_#{system_name}",
              parameters: entity_params
            }
          ]
        }
    ],
    info: {},
    basePath: "#{base_url}/api/#{project.system_name}",
    resourcePath: "/#{system_name}"
    }
    hash

  end


  def entity_params
    arr = []
    inputs.each do |name, kind|
      arr << {
        name: name,
        required: false,
        paramType: "query",
        type: kind

      }
    end
    arr
  end

end
