# frozen_string_literal: true
class BatchesController < ApplicationController
  def show
    render json: Batch.find_by!(caller_id: params[:id]), include: ['emails', 'emails.events']
  end
end
