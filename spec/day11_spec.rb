require 'rspec'
require_relative '../day11/top_fuel_cell'
require_relative '../day11/largest_total_power'

power_level_examples = [
    { coordinates: [3, 5], serial: 8, power: 4 },
    { coordinates: [122, 79], serial: 57, power: -5 },
    { coordinates: [217, 196], serial: 39, power: 0 },
    { coordinates: [101, 153], serial: 71, power: 4 },
]

describe '#fuel_cell_power_level' do
   power_level_examples.each do |example|
    serial_number = example[:serial]
    coordinates = example[:coordinates]
    power = example[:power]
    it "gives the right power level for coordinates #{coordinates.inspect} and serial #{serial_number}" do
      expect(fuel_cell_power_level(coordinates[0], coordinates[1], serial_number: serial_number)).to eq(power)
    end
  end
end

coordinates_examples = [
    { input: 18, coordinates: [33, 45], total_power: 29 },
    { input: 42, coordinates: [21, 61], total_power: 30 },
]
describe '#top_coordinates' do
  coordinates_examples.each do |example|
    serial_number = example[:input]
    coordinates = example[:coordinates]
    it "gives the right coordinates for grid serial number #{serial_number}" do
      expect(top_coordinates(serial_number)).to eq(coordinates)
    end
  end
end

coordinates_examples = [
    { input: 18, coordinates: [90,269,16], total_power: 113 },
    { input: 42, coordinates: [232,251,12], total_power: 119 },
]
describe '#largest_total_power' do
  coordinates_examples.each do |example|
    serial_number = example[:input]
    coordinates = example[:coordinates]
    it "gives the right coordinates for grid serial number #{serial_number}" do
      expect(largest_total_power(serial_number)).to eq(coordinates)
    end
  end
end