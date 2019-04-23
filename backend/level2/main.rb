require_relative 'models/car'
require_relative 'models/rental'
require 'json'

json_data = JSON.parse(File.read('data/input.json'))
cars = []
rentals = []

# We create car and rental instances from the json
json_data['cars'].each do |car|
  cars << Car.new(car)
end

json_data.dig('rentals').each do |rental|
  rented_car = cars.select { |car| car.id == rental['car_id']}
  rentals << Rental.new(rental, rented_car.first)
end

rentals.map! { |rental| {id: rental.id, price: rental.price} }

# Now that the data is ready, let's generate the output file
File.open("data/expected_output.json","w") do |f|
  f.write(JSON.pretty_generate({rentals: rentals}))
end
