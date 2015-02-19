class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :entity

end
