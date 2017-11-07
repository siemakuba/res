require 'rubygems'
require 'bundler/setup'
require "aws-sdk"

Aws.config.update({
  region: "us-west-2",
  endpoint: "http://localhost:8000"
})

dynamodb = Aws::DynamoDB::Client.new

data = dynamodb.scan({table_name: 'Events'})

puts "All items in table: #{data.count}"
puts
puts "Stored items:"
data.items.each do |row|
  puts row
end
