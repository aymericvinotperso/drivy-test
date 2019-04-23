class Comission

  def initialize(rental)
    @price = rental.price
    @rental_duration = rental.rental_duration
  end

  def to_hash
    {
    insurance_fee: insurance_fee,
    assistance_fee: insurance_fee,
    drivy_fee: insurance_fee
    }
  end

  private

  def total_fee
    @price * 0.3
  end

  def insurance_fee
    total_fee * 0.5
  end

  def assistance_fee
    @rental_duration * 100
  end

  def drivy_fee
    total_fee - insurance_fee - assistance_fee
  end
end
