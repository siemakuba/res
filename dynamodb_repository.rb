
class DynamodbRepository
  def initialize(dynamodb_client: Aws::DynamoDB::Client.new)
    @dynamodb_client = dynamodb_client
  end

  def create(event, stream_name)
    dynamodb_client.put_item(
      table_name: 'Events',
      item: event_data(event, stream_name)
    )
  end

  private

  attr_reader :dynamodb_client

  def event_data(event, stream_name)
    {
      id: SecureRandom.uuid,
      info: {
        stream_name: stream_name.to_s,
        event_type: event.class.to_s,
        metadata: normalized_data(event.metadata),
        data: normalized_data(event.data)
      }
    }
  end

  def normalized_data(data)
    {}.tap do |normalized|
      data.to_h.each do |key, value|
        value = case value
          when Hash, Array, Set, String, Numeric, TrueClass, FalseClass, nil
            value
          else
            value.to_s
          end

        normalized[key] = value
      end
    end
  end
end
