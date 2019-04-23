class Car
  attr_reader :id, :price_per_day, :price_per_km

  # Because of comission rules, price can't be too low
  validates :price_per_day, numericality: { greater_than: 1000 }

  def initialize(attributes = {})
    @id = attributes['id']
    @price_per_day = attributes['price_per_day']
    @price_per_km = attributes['price_per_km']
  end
end
