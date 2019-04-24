require_relative 'models/car'
require_relative 'models/rental'
require_relative 'models/paiement'
require 'json'

def generate_json_output(json_input)
  cars = []
  rentals = []

  # We create car and rental instances from the input json
  json_input['cars'].each { |car| cars << Car.new(car) }

  json_input['rentals'].each do |rental|
    rented_car = cars.select { |car| car.id == rental['car_id'] }.first

    options_hash = {}
    rental_options = json_input['options'].select { |option| rental['id'] == option['rental_id'] }
    rental_options.each { |option| options_hash[option['type']] = true }

    rentals << Rental.new(rented_car, rental, options_hash)
  end

  # Then generate the json output
  rentals.map! do |rental|
    { id: rental.id, options: rental.options.keys, actions: Paiement.new(rental).actions }
  end

  JSON.pretty_generate(rentals: rentals)
end

# Now, time to call our method and put the json on output.json
json_input = JSON.parse(File.read('data/input.json'))
json_output = generate_json_output(json_input)

File.open('data/real_output.json', 'w') do |f|
  f.write(json_output)
end
