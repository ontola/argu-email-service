# frozen_string_literal: true
namespace :rabbitmq do
  desc 'Subscribe to rabbitmq to receive email requests'
  task subscribe: :environment do
    conn = Bunny.new
    conn.start

    ch = conn.create_channel
    x = ch.fanout('mails', durable: true)
    q = ch.queue('mails.batches', durable: true)

    q.bind(x)

    puts ' [*] Waiting for mail. To exit press CTRL+C'

    begin
      q.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
        puts " [x] #{delivery_info.routing_key}:#{JSON.parse(body)}"
        params = JSON.parse(body)['data']['attributes']
        Batch.create(params.slice('template', 'options', 'caller_id'))

        ch.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt
      conn.close
    end
  end
end
