class Entity
  include Mongoid::Document
  include Mongoid::Timestamps

  KINDS = [String,
           Fixnum,
           Float,
           Date,
           DateTime,
           # Time,
           Boolean,
           # Hash,
           # Array,
           # Range,
           # Symbol
  ]

  include SystemName
  has_system_name uniqueness_scope: true

  field :inputs, type: Hash, default: {title: String.new}

  belongs_to :project
  has_many :items

  def keys
    inputs.keys
  end


  def filtered_items(params)
    scope = self.items
    inputs.each do |name, kind|
      if att = params[name]
        scope = scope.where({name => Casting::parse(att, kind.to_s)})
      end
    end
    scope
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
              summary: "List #{name.pluralize}",
              nickname: "index",
              parameters: paginate_params + filter_params
            },
            {
              method: "POST",
              summary: "Create a #{name.singularize}",
              nickname: "create",
              parameters: entity_params
            }
          ]
        },
        {
          path: "/#{system_name}/{id}",
          operations: [
            {
              method: "GET",
              summary: "Find a #{name.singularize}",
              nickname: "show",
              parameters: get_params
            },
            {
              method: "PUT",
              summary: "Modify a #{name.singularize}",
              nickname: "update",
              parameters: get_params + entity_params
            },
            {
              method: "DELETE",
              summary: "Destroy a #{name.singularize}",
              nickname: "destroy",
              parameters: get_params
            }
          ]
        }
    ],
    info: {
      name: "#{name} API data",
    },
    basePath: "#{base_url}/api/#{project.system_name}",
    resourcePath: "/#{system_name}"
    }
    hash

  end

  def get_params
    [
      {
        name: "id",
        required: true,
        paramType: "path",
        type: "string"
      }
    ]
  end

  def filter_params
    inputs.map do |name, kind|
      {
        name: name,
        required: false,
        paramType: "query",
        type: kind
      }
    end
  end

  def paginate_params
    [
      {
        name: "page",
        required: false,
        paramType: "query",
        type: "integer",
        defaultValue: 1
      },
      {
        name: "per_page",
        required: false,
        paramType: "query",
        type: "integer",
        defaultValue: 50
      }
    ]
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

  def apisio_spec(base_url)
    {
      name: "API #{name}",
      description: "#{name} restfull data API",
      image: "#{base_url}/logo.png",
      baseURL: base_url,
      humanURL: base_url,
      properties:[],
      contact:[]
    }
  end
end
