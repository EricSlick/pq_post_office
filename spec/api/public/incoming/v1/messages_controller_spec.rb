require 'rails_helper'

RSpec.describe 'Api::Public::Incoming::V1::Messages', type: :request do
  describe '#create' do
    it 'creates a message' do
      post api_public_incoming_messages_v1_messages_path,
           params: {phone: '123456789', body: 'This is a message body', key: '12345'}
      expect(response).to be_successful
      expect(Message.last.phone).to eq '123456789'
    end
  end

  describe '#create_test_data' do
    it 'calls the incoming API to create messages' do
      num_to_create = 2
      get create_test_data_api_public_incoming_messages_v1_messages_path, params: {num: num_to_create}
      expect(response).to be_successful
      expect(Message.count).to eq num_to_create
    end
  end
end