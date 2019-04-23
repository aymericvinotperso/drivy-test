require_relative 'models/car'
require_relative 'models/rental'
require_relative 'models/paiement'
require 'json'

def generate_json_output(json_input)
  cars = []
  rentals = []

  # We create car and rental instances from the input json
  json_input['cars'].each do |car|
    cars << Car.new(car)
  end

  json_input.dig('rentals').each do |rental|
    rented_car = cars.select { |car| car.id == rental['car_id']}
    rentals << Rental.new(rental, rented_car.first)
  end

  # Then generate the json output
  rentals.map! do
    |rental| {id: rental.id, actions: Paiement.new(rental).actions }
  end

  JSON.pretty_generate({rentals: rentals})
end


# Now, time to call our method and put the json on output.json
json_input = JSON.parse(File.read('data/input.json'))
json_output = generate_json_output(json_input)

File.open("data/output.json","w") do |f|
  f.write(json_output)
end
