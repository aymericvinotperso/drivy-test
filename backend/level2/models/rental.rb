require 'date'

class Rental
  attr_reader :id

  def initialize(attributes = {}, car)
    @id = attributes['id']
    @start_date = DateTime.parse(attributes['start_date']).to_date
    @end_date = DateTime.parse(attributes['end_date']).to_date
    @distance = attributes['distance']
    @car = car
  end

  def price
    price_for_time + price_for_distance
  end

  private

  # These constants define long rental discount rules
  AFTER_ONE_DAY_PRICE = 0.9
  AFTER_FOUR_DAY_PRICE = 0.7
  AFTER_TEN_DAY_PRICE = 0.5

  def rental_duration
    (1 + (@end_date - @start_date).to_i)
  end

  def price_for_time
    daily_price = @car.price_per_day
    price = daily_price

    (2..rental_duration).each do |day|
      price += daily_price * AFTER_ONE_DAY_PRICE if day > 1 && day < 5
      price += daily_price * AFTER_FOUR_DAY_PRICE if day > 4 && day < 11
      price += daily_price * AFTER_TEN_DAY_PRICE if day > 10
    end

    price.to_i
  end

  def price_for_distance
    @distance * @car.price_per_km
  end
end
