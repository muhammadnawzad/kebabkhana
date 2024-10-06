class Humanize < Marten::Template::Filter::Base
  def apply(value : Marten::Template::Value, arg : Marten::Template::Value? = nil) : Marten::Template::Value
    Marten::Template::Value.from(value.to_s.gsub(/_/, ' ').capitalize)
  end
end

Marten::Template::Filter.register("humanize", Humanize)
