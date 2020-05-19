# frozen_string_literal: true

class ApplicationController < APIController
  private

  def serializer_params
    {
      scope: user_context
    }
  end
end
