class Item
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :entity

  def id
    _id.to_s
  end

  def self.filters(params)
    self
  end

  def assing_params(params)
    entity.inputs.each do |name, kind|
      att = params[name]
      if att
        begin
          case kind
          when "Fixnum"
            value = att.to_i
          when "Float"
            value = att.to_f
          when "Boolean"
            value = att ? true : false
          when "Date"
            self[name.to_sym] = kind.constantize.parse(att)
          when "DateTime"
            self[name.to_sym] = kind.constantize.parse(att)
          else
            self[name.to_sym] = kind.constantize.new(att)
          end
        rescue Exception => e
          p e
        end

      end
    end
  end
end
