class DashController < ApplicationController
  def index
    @messages = Message.with_phone(dash_params[:search_phone])
  end

  private

  def dash_params
    params.permit(:search_phone)
  end
end
