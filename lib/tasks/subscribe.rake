# frozen_string_literal: true
namespace :broadcast do
  desc 'Subscribe to rabbitmq'
  task subscribe: :environment do
    Broadcast::Connection.subscribe do |data_event|
      type = "#{data_event.resource_type}Event"
      Event.create!(data_event.instance_values.merge(type: type)) if type.safe_constantize.present?
    end
  end
end
