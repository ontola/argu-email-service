# frozen_string_literal: true

endpoints_key = 'frontend.runtime.plain_endpoints'
db = 0

begin
  current_keys = Redis.new(db: db).lrange(endpoints_key, 0, -1)
  required_keys = %w[
    /email/_public/email_events
  ]

  (required_keys - current_keys).each do |key|
    Rails.logger.info "Registering #{key} as API endpoint"
    Redis.new(db: db).lpush(endpoints_key, key)
  end
rescue ::Redis::CannotConnectError
  Rails.logger.info 'Failed to connect to Redis to register API endpoints'
end
