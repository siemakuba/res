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

data.items.each do |row|
  puts "#{row['id']} / #{row['info']['event_type']} / #{row['info']['metadata']}"
end
