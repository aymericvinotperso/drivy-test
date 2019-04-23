require 'date'

class Rental
  attr_reader :id

  def initialize(attributes = {}, car)
    @id = attributes['id']
    @start_date = DateTime.parse(attributes['start_date']).to_date
    @end_date = DateTime.parse(attributes['end_date']).to_date
    @distance = attributes['distance']
    @car = car.first
  end

  def price
    price_for_time + price_for_distance
  end

  private

  def price_for_time
    (1 + (@end_date - @start_date).to_i) * @car.price_per_day
  end

  def price_for_distance
    @distance * @car.price_per_km
  end
end
