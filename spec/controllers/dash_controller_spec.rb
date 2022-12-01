require 'rails_helper'

RSpec.describe "Dash", type: :request do

  let(:messages) do
    Message.create(
      [
        {
          status: Message::STATUS[:received],
          phone: '1223456789',
          body: 'first test message'
        },
        {
          status: Message::STATUS[:received],
          phone: '987654321',
          body: 'second test message'
        }
      ])
  end

  it 'requests a list of messages' do
    messages
    get dash_index_path
    expect(response).to be_successful
    messages.each do |message|
      expect(response.body).to include(message.status)
      expect(response.body).to include(message.phone)
      expect(response.body).to include(message.body)
    end
  end
end