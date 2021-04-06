class Api::V1::UtilsController < ApplicationController
  def subscribe
    email = params['subscribe']['email']
    sub = Subscribe.new(email: email)
    if sub.save
      render json: { status: 'ok'}
    else
      # render json: { status: 'failed', messages: sub.errors.full_messages, email: email }
      render json: { status: 'failed', messages: sub.errors.full_messages }
    end
  end
end
