require 'string_ext'

class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :entity

  def id
    _id.to_s
  end

  def assing_params(params)
    entity.inputs.each do |name, kind|
      att = params[name]
      if att
        self[name.to_sym] = Casting::parse(att, kind.to_s)
      end
    end
  end
end
