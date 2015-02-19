class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :entity

  def id
    _id.to_s
  end

  def assing_params(params)
    params.slice(*entity.keys).each do |key, value|
      self[key.to_sym] = value
    end
  end
end
