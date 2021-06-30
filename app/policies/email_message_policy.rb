# frozen_string_literal: true

class EmailMessagePolicy < RestrictivePolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    service_scope?
  end

  def index?
    service_scope?
  end

  def show?
    service_scope?
  end
end
