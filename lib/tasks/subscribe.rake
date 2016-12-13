# frozen_string_literal: true
namespace :rabbitmq do
  desc 'Subscribe to rabbitmq to receive email requests'
  task subscribe: :environment do
    conn = Bunny.new
    conn.start

    ch = conn.create_channel
    x = ch.fanout('events', durable: true)
    q = ch.queue('events', durable: true)

    q.bind(x)

    puts ' [*] Waiting for events. To exit press CTRL+C'

    begin
      q.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
        puts " [x] #{delivery_info.delivery_tag}:#{JSON.parse(body)}"
        attributes = JSON.parse(body)
        attributes[:type] = "#{attributes['resource_type']}Event"
        Event.create!(attributes) if attributes[:type].safe_constantize.present?
        ch.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt
      conn.close
    end
  end
end
