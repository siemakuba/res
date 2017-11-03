require 'rubygems'
require 'bundler/setup'
require 'ruby_event_store'

FooEvent = Class.new(RubyEventStore::Event)
BarEvent = Class.new(RubyEventStore::Event)
OtherEvent = Class.new(RubyEventStore::Event)

class FooEventHandler
  def call(event)
    puts "   - FooEventHandler received #{event.class} with data: #{event.data}"
  end
end

class BarEventHandler
  def call(event)
    puts "   - BarEventHandler received #{event.class} with data: #{event.data}"
  end
end

class GeneralEventHandler
  def call(event)
    puts "   - GeneralEventHandler received #{event.class} with data: #{event.data}"
  end
end

event_store = RubyEventStore::Client.new(repository: RubyEventStore::InMemoryRepository.new)

event_store.subscribe(FooEventHandler.new, [FooEvent])
event_store.subscribe(BarEventHandler.new, [BarEvent])
event_store.subscribe(GeneralEventHandler.new, [FooEvent, BarEvent, OtherEvent])


puts
puts "* Publishing FooEvent"
event_store.publish_event(FooEvent.new(data: {sample: "Foo Event Data"}))

puts
puts "* Publishing BarEvent"
event_store.publish_event(BarEvent.new(data: {sample: "Bar Event Data"}))

puts
puts "* Publishing OtherEvent"
event_store.publish_event(OtherEvent.new(data: {sample: "Other Event Data"}))

puts
