# frozen_string_literal: true

Tenant.create('argu') unless ApplicationRecord.connection.schema_exists?('argu')
