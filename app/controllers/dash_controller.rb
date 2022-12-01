class DashController < ApplicationController
  def index
    @messages = Message.all
  end
end
