# frozen_string_literal: true

class EmailMessagesController < ApplicationController
  include LinkedRails::Controller

  active_response :show
end
