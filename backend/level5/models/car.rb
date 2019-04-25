class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(attributes = {})
    @id = attributes.fetch('id')
    @price_per_day = attributes.fetch('price_per_day')
    @price_per_km = attributes.fetch('price_per_km')
  end
end
