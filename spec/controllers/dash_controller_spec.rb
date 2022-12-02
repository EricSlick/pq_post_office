require 'rails_helper'

RSpec.describe 'Dash', type: :request do

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
        },
        {
          status: Message::STATUS[:received],
          phone: '5552344321',
          body: 'third test message'
        }
      ])
  end

  it 'requests a list of messages' do
    messages
    get dashes_path
    expect(response).to be_successful
    messages.each do |message|
      expect(response.body).to include(message.status)
      expect(response.body).to include(message.phone)
      expect(response.body).to include(message.body)
    end
  end

  context 'search by phone number' do
    it 'returns only the matching messages' do
      messages
      get dashes_path, params: { search: { phone: '987654321' }}
      expect(response.body).to_not include(messages[0].phone)
      expect(response.body).to_not include(messages[2].phone)
      expect(response.body).to include(messages[1].phone)
    end
  end
end