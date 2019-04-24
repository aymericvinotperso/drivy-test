# frozen_string_literal: true
require 'date'

class Rental
  attr_reader :id, :options

  def initialize(car, attributes = {}, options)
    @id = attributes['id']
    @car = car
    @start_date = DateTime.parse(attributes['start_date']).to_date
    @end_date = DateTime.parse(attributes['end_date']).to_date
    @distance = attributes['distance']
    @options = options
  end

  def duration
    (1 + (@end_date - @start_date).to_i)
  end

  def price_excluding_options
    price_for_time + price_for_distance
  end

  # These constants define option prices
  GPS_PRICE = 500
  BABY_SEAT_PRICE = 200
  ADDITIONAL_INSURANCE_PRICE = 1000

  def price_for_equipment_options
    price = 0
    price += GPS_PRICE * duration if @options['gps']
    price += BABY_SEAT_PRICE * duration if @options['baby_seat']

    price
  end

  def price_for_insurance_options
    @options['additional_insurance'] ? ADDITIONAL_INSURANCE_PRICE * duration : 0
  end

  def total_price
    price_excluding_options + price_for_equipment_options + price_for_insurance_options
  end

  private

  # These constants define long rental discount rules
  AFTER_ONE_DAY_PRICE = 0.9
  AFTER_FOUR_DAY_PRICE = 0.7
  AFTER_TEN_DAY_PRICE = 0.5

  def price_for_time
    daily_price = @car.price_per_day
    price = daily_price

    (2..duration).each do |day|
      price += daily_price * AFTER_ONE_DAY_PRICE if day.between?(2, 4)
      price += daily_price * AFTER_FOUR_DAY_PRICE if day.between?(5, 10)
      price += daily_price * AFTER_TEN_DAY_PRICE if day > 10
    end

    price.to_i
  end

  def price_for_distance
    @distance * @car.price_per_km
  end
end
