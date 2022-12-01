class DashController < ApplicationController
  def index
    phone = dash_params.fetch(:search, {})
    phone_num = phone['phone']
    @messages = Message.with_phone(phone_num)
  end

  private

  def dash_params
    params.permit(search: [:phone])
  end
end
