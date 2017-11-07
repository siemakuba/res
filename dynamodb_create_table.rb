require 'rubygems'
require 'bundler/setup'
require "aws-sdk"

Aws.config.update({
  region: "us-west-2",
  endpoint: "http://localhost:8000"
})

dynamodb = Aws::DynamoDB::Client.new

params = {
  table_name: "Events",
  key_schema: [
    {
      attribute_name: "id",
      key_type: "HASH"
    }
  ],
  attribute_definitions: [
    {
      attribute_name: "id",
      attribute_type: "S"
    }
  ],
  provisioned_throughput: {
    read_capacity_units: 10,
    write_capacity_units: 10
  }
}

begin
  dynamodb.delete_table({table_name: 'Events'})

  result = dynamodb.create_table(params)
  puts "Created table. Status: #{result.table_description.table_status}"

rescue  Aws::DynamoDB::Errors::ServiceError => error
  puts "Unable to create table:"
  puts "#{error.message}"
end
