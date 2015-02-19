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
end
