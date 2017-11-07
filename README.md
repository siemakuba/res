## Using RailsEventStore outside of Rails

The RailsEventStore gem can be easily used outside of Rails. To accomplish this you need to use the RubyEventStore gem, wchich is a part of RailsEventStore. It comes without any additional dependencies. 

RubyEventStore uses InMemoryRepository as a storage backend - this means that published events are not persisted.

```ruby
event_store = RubyEventStore::Client.new(
  repository: RubyEventStore::InMemoryRepository.new
)
```

## Using RubyEventStore with Amazon DynamoDB as a backend

It's fairly easy to create a simple backend repository for storing published events. The simplest use case requires creating an object responding to `create` method, accepting two arguments: `event` object and `stream_name` value.

```ruby
class DynamodbRepository
  def create(event, stream_name)
    # DynamoDB persistance logic
  end
end
```


## Example use case

### 1. Install and run local instance of Amazon DynamoDB
Follow the instructions at http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html to install the databse locally.

Start the database server: (adjust the path accordingly)

```bash
$ java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb
```

### 2. Clone this repo and install dependencies

```bash
$ git clone git@github.com:siemakuba/res.git
gem install bundler
bundle install
```

### 2. Prepare a table for storing events
Execute the code in `dynamodb_create_table.rb`:

```bash
$ ruby dynamodb_create_table.rb
```

You should see the following output:

```bash
Created table. Status: ACTIVE
```

### 3. Publish some events
Execute the code in `events.rb`:

```bash
$ ruby events.rb
```

You should see the following output, indicating that event has been published and consumed:

```bash
* Publishing FooEvent
   - FooEventHandler received FooEvent with data: {:sample=>"Foo Event Data"}
   - GeneralEventHandler received FooEvent with data: {:sample=>"Foo Event Data"}

* Publishing BarEvent
   - BarEventHandler received BarEvent with data: {:sample=>"Bar Event Data"}
   - GeneralEventHandler received BarEvent with data: {:sample=>"Bar Event Data"}

* Publishing OtherEvent
   - GeneralEventHandler received OtherEvent with data: {:sample=>"Other Event Data"}

```

### 4. Verify that the events has been stored inside Dynamo DB

Execute the code in `dynamodb_read_table.rb`:

```bash
$ ruby dynamodb_read_table.rb
```

You should see the following output, showing the stored events:

```bash
All items in table: 3

Stored items:
{"id"=>"e32926cf-1bc7-4a56-b3ba-1bf52597a957", "timestamp"=>"2017-11-07T09:54:54.334293+01:00", "info"=>{"metadata"=>{"timestamp"=>"2017-11-07T09:54:54+01:00"}, "event_type"=>"BarEvent", "stream_name"=>"all", "data"=>{"sample"=>"Bar Event Data"}}}
{"id"=>"dabd1724-a3bc-4279-9aee-f8eb73da5c90", "timestamp"=>"2017-11-07T09:54:54.322915+01:00", "info"=>{"metadata"=>{"timestamp"=>"2017-11-07T09:54:54+01:00"}, "event_type"=>"FooEvent", "stream_name"=>"all", "data"=>{"sample"=>"Foo Event Data"}}}
{"id"=>"463a3b6d-cf76-4634-80ed-5a7986158d52", "timestamp"=>"2017-11-07T09:54:54.342175+01:00", "info"=>{"metadata"=>{"timestamp"=>"2017-11-07T09:54:54+01:00"}, "event_type"=>"OtherEvent", "stream_name"=>"all", "data"=>{"sample"=>"Other Event Data"}}}
```
