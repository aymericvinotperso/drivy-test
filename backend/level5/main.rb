require_relative 'models/car'
require_relative 'models/rental'
require_relative 'models/paiement'
require 'json'

def generate_rental_instances(json_input)
    cars = json_input['cars'].map { |car| Car.new(car) }

    json_input['rentals'].map do |rental|
      rented_car = cars.select { |car| car.id == rental['car_id'] }.first

      rental_options = json_input['options'].select { |option| rental['id'] == option['rental_id'] }
                                            .map { |option| option['type'] }

      Rental.new(rented_car, rental, rental_options)
    end
end

def generate_json_output(json_input)
  rentals = generate_rental_instances(json_input)

  rentals.map! do |rental|
    { id: rental.id, options: rental.options, actions: Paiement.new(rental).actions }
  end

  JSON.pretty_generate(rentals: rentals)
end

# Now, time to call our method and put the json on output.json
json_input = JSON.parse(File.read('data/input.json'))
json_output = generate_json_output(json_input)

File.open('data/real_output.json', 'w') do |f|
  f.write(json_output)
end
