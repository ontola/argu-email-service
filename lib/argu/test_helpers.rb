# frozen_string_literal: true

require 'sidekiq/testing'
require 'argu/test_helpers/request_helpers'

# Runs assert_difference with a number of conditions and varying difference
# counts.
#
# @example
#   assert_differences([['Model1.count', 2], ['Model2.count', 3]])
#
def assert_differences(expression_array, message = nil, &block)
  b = block.send(:binding)
  before = expression_array.map { |expr| eval(expr[0], b) }

  yield

  expression_array.each_with_index do |pair, i|
    e = pair[0]
    difference = pair[1]
    error = "#{e.inspect} didn't change by #{difference}"
    error = "#{message}\n#{error}" if message
    assert_equal(before[i] + difference, eval(e, b), error)
  end
end

def create_event(event, id, type, opts = {})
  ActsAsTenant.with_tenant(Page.default) do
    Event.create!(
      event: event,
      resource_id: id,
      resource_type: type,
      type: "#{type.classify}Event",
      body: create_event_body(event, id, type, opts)
    )
  end
end

def create_event_body(event, id, type, opts)
  {
    resource_id: id,
    resource_type: type,
    affected_resources: opts[:affected_resources],
    changes: [{id: id, type: type, attributes: opts[:changes]}],
    event: event,
    resource: create_event_resource(id, type, opts)
  }
end

def create_event_resource(id, type, opts)
  {
    id: id,
    type: type,
    attributes: opts[:attributes],
    relationships: opts[:relationships]
  }
end

def use_legacy_frontend
  @use_legacy_frontend = true
end

def use_legacy_frontend?
  @use_legacy_frontend == true
end
