# frozen_string_literal: true

module TokenHelper
  def group
    @record.event.group
  end

  def organization
    @record.event.group.organization
  end

  def profile
    ActiveResourceModel.find(:one, from: @record.event.resource['actorIRI'])
  end
end
