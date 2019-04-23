# frozen_string_literal: true
class Paiement

  def initialize(rental)
    @price = rental.price
    @rental_duration = rental.rental_duration
  end

  def actions
    [driver_paiement, owner_paiement, insurance_paiement, assistance_paiement, drivy_paiement]
  end

  private

  TOTAL_CUT_RATE = 0.3
  INSURANCE_CUT_RATE = 0.5
  ASSITANCE_DAILY_CUT = 100

  def total_fee
    (@price * TOTAL_CUT_RATE).to_i
  end

  def insurance_fee
    (total_fee * INSURANCE_CUT_RATE).to_i
  end

  def assistance_fee
    (@rental_duration * ASSITANCE_DAILY_CUT).to_i
  end

  def drivy_fee
    ([total_fee - insurance_fee - assistance_fee, 0].max).to_i
  end

  def driver_paiement
    {
      who: "driver",
      type: "debit",
      amount: @price
    }
  end

  def owner_paiement
    {
      who: "owner",
      type: "credit",
      amount: (@price * (1 - TOTAL_CUT_RATE)).to_i
    }
  end

  def insurance_paiement
    {
      who: "insurance",
      type: "credit",
      amount: insurance_fee
    }
  end

  def assistance_paiement
    {
      who: "assistance",
      type: "credit",
      amount: assistance_fee
    }
  end

  def drivy_paiement
    {
      who: "drivy",
      type: "credit",
      amount: drivy_fee
    }
  end
end
