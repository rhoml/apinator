module Casting

  def self.parse(value, kind)
    begin
      case kind
      when "Fixnum"
        value.to_i
      when "Float"
        value.to_f
      when "Boolean"
        value.to_bool
      when "Date"
        kind.constantize.parse(value)
      when "DateTime"
        kind.constantize.parse(value)
      else
        kind.constantize.new(value)
      end
    rescue Exception => e
      p e
      nil
    end
  end
end
