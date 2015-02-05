#!/usr/bin/env ruby
require 'csv'

# Read input data
input = CSV.read('input.csv', headers: true)

# Build all combinations
ordered = []
rows = input.count

(0...rows).each do |bigrow|
  (0...rows).each do |smallrow|
    (0...rows).each do |backrow|
      if backrow != bigrow && backrow != smallrow && bigrow != smallrow
        if true
          ordered << [input[backrow]["background"], input[smallrow]["small"], input[bigrow]["big"]]
        end
      end
    end
  end
end

# Sort so that no adjacent lines have the same colour
# There must be a better, more functional way to do this
randomised = ordered.shuffle
outputlist = []
previousrow = ['','','']
while randomised.count != 0
  nextrow = randomised.find { |row| row[0] != previousrow[0] && row[1] != previousrow[1] && row[2] != previousrow[2]}
  if nextrow.nil?
    nextrow = randomised.first
  end
  # Store in randomised list
  outputlist << nextrow
  # Remove from the ordered list
  randomised.delete nextrow
  # Remember the row for next time around
  previousrow = nextrow
end

# Save CSV
CSV.open("output.csv", "w") do |csv|
  outputlist.each do |row|
    csv << row
  end
end