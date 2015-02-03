#!/usr/bin/env ruby
require 'csv'

# Read input data
input = CSV.read('input.csv', headers: true)

# Build all combinations
ordered = []
rows = input.count

(0...rows).each do |bigrow|
  (0...rows).each do |smallrow|
    if smallrow != bigrow
      (0...rows).each do |backrow|
        if backrow != bigrow
          ordered << [input[backrow]["background"], input[smallrow]["small"], input[bigrow]["big"]]
        end
      end
    end
  end
end

# Sort so that no adjacent lines have the same colour
ordered.shuffle!
randomised = []
previousrow = ['','','']
while ordered.count != 0
  nextrow = ordered.find { |row| row[0] != previousrow[0] && row[1] != previousrow[1] && row[2] != previousrow[2]}
  if nextrow.nil?
    nextrow = ordered.first
  end
  # Store in randomised list
  randomised << nextrow
  # Remove from the ordered list
  ordered.delete nextrow
  # Remember the row for next time around
  previousrow = nextrow
end

# Save CSV
CSV.open("output.csv", "w") do |output|
  randomised.each do |row|
    output << row
  end
end