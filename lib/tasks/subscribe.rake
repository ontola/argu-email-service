# frozen_string_literal: true

namespace :broadcast do
  desc 'Subscribe to rabbitmq'
  task subscribe: :environment do
    Connection.subscribe('email_service') do |data_event|
      type = "#{data_event.resource_type.classify}Event"
      if type.safe_constantize.present?
        ActsAsTenant.with_tenant(TenantFinder.from_url(data_event.resource_id)) do
          if ActsAsTenant.current_tenant.blank?
            Bugsnag.notify("No tenant found for #{data_event.resource_id}") do |report|
              report.add_tab(:event, data_event.as_json)
            end
          else
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
  end
end
