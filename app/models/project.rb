class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  include SystemName
  has_system_name uniqueness_scope: true

  belongs_to :user
  has_many :entities

  validates :name, presence: true
end
