class DashController < ApplicationController
  def index
    phone_num = dash_params['search']
    Rails.logger.info("=====> phone_num = #{phone_num}")
    @messages = Message.with_phone(phone_num)
  end

  private

  def dash_params
    params.permit(:search)
  end
end
