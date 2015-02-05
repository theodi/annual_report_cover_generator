#!/usr/bin/env ruby
require 'csv'

# Read input data
input = CSV.read('input.csv', headers: true)

# Build all combinations
ordered = []
rows = input.count

# Banned combinations
def banned?(back, small, big)
  colours = [back, small, big]
  # Are any the same?
  return true if colours.uniq.count != colours.count
  # Are any in banned combinations?
  [
    [9,8,11,10,0,14,12],
    [12,13,14],
    [7,8,9],
    [3,4],
    [4,5],
    [0,1]
  ].any? do |arr|
    # There should be no more than one colour in our array in the exclusion list
    return true if (arr & colours).count > 1
  end
  return false
end

(0...rows).each do |bigrow|
  (0...rows).each do |smallrow|
    (0...rows).each do |backrow|
      unless banned?(backrow, smallrow, bigrow)
        ordered << [input[backrow]["background"], input[smallrow]["small"], input[bigrow]["big"]]
      end
    end
  end
end

# Sort so that no adjacent lines have the same colour
# There must be a better, more functional way to do this
randomised = ordered.shuffle
outputlist = []
previousrow = [nil,nil,nil]
# background colour
bgcol = 0
while randomised.count != 0
  nextrow = randomised.find { |row| row[0] == input[bgcol]["background"] && row[1] != previousrow[1] && row[2] != previousrow[2]}
  if nextrow.nil?
    # Just take the next row
    nextrow = randomised.first
  end
  # Store in randomised list
  outputlist << nextrow
  # Remove from the ordered list
  randomised.delete nextrow
  # Remember the row for next time around
  previousrow = nextrow
  # Next background colour
  bgcol = (bgcol + 1) % 15
end

# Save CSV
CSV.open("output.csv", "w") do |csv|
  outputlist.each do |row|
    csv << row
  end
end