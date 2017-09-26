# frozen_string_literal: true

namespace :broadcast do
  desc 'Subscribe to rabbitmq'
  task subscribe: :environment do
    Connection.subscribe('email_service') do |data_event|
      type = "#{data_event.resource_type.singularize.capitalize}Event"
      if type.safe_constantize.present?
        Event.create!(
          type: type,
          event: data_event.event,
          resource_id: data_event.resource_id,
          resource_type: data_event.resource_type,
          body: data_event.instance_values
        )
      end
    end
  end
end
