# frozen_string_literal: true
class Paiement
  def initialize(rental)
    @rental = rental
  end

  def actions
    [driver_paiement, owner_paiement, insurance_paiement, assistance_paiement, drivy_paiement]
  end

  private

  # These constants define how cuts work
  TOTAL_CUT_RATE = 0.3
  INSURANCE_CUT_RATE = 0.5
  ASSITANCE_DAILY_CUT = 100

  def total_cut
    (@rental.price_excluding_options * TOTAL_CUT_RATE).round
  end

  def insurance_fee
    (total_cut * INSURANCE_CUT_RATE).round
  end

  def assistance_fee
    (@rental.duration * ASSITANCE_DAILY_CUT).round
  end

  def drivy_fee
    total_cut - insurance_fee - assistance_fee + @rental.price_for_insurance_options
  end

  def owner_fee
    @rental.price_excluding_options - total_cut + @rental.price_for_equipment_options
  end

  def driver_paiement
    {
      who: 'driver',
      type: 'debit',
      amount:  @rental.total_price
    }
  end

  def owner_paiement
    {
      who: 'owner',
      type: 'credit',
      amount: owner_fee
    }
  end

  def insurance_paiement
    {
      who: 'insurance',
      type: 'credit',
      amount: insurance_fee
    }
  end

  def assistance_paiement
    {
      who: 'assistance',
      type: 'credit',
      amount: assistance_fee
    }
  end

  def drivy_paiement
    {
      who: 'drivy',
      type: 'credit',
      amount: drivy_fee
    }
  end
end
