require 'rspec'
require_relative './main.rb'

RSpec.describe "Rental price calculation" do
  let(:data)            { JSON.parse(File.read('data/input.json')) }
  let(:expected_output) { JSON.pretty_generate(JSON.parse(File.read('data/expected_output.json'))) }

  it 'should generate a json file equal to expected_output.json' do
    expect(generate_json_output(data)).to eq(expected_output)
  end
end
