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
        begin
          if [Fixnum, Float, Boolean].include?(kind.constantize)
            self[name.to_sym] = att
          elsif [Date, DateTime].include?(kind.constantize)
            self[name.to_sym] = kind.constantize.parse(att)
          else
            self[name.to_sym] = kind.constantize.new(att)
          end
        rescue Exception => e
          p e
        end

      end
    end


    # params.slice(*entity.keys).each do |key, value|
      # self[key.to_sym] = value
    # end
  end
end
