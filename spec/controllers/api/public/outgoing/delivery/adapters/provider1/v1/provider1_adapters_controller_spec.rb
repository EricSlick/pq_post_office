require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::Adapters::Provider1::V1::Provider1AdaptersController, type: :controller do
  let(:subject){ Api::Public::Outgoing::Delivery::Adapters::Provider1::V1::Provider1AdaptersController.new }
  let(:message) do
    Message.create(
      status: Message::STATUS[:received],
      phone: Faker::PhoneNumber.cell_phone,
      body: Faker::Lorem.sentences
    ).reload
  end
  let(:faraday) do
    Faraday.new(
      url: 'https::/test.com',
      params: {},
      headers: {'Content-Type' => 'application/json'}
    )
  end
  let(:response) { double(body: {message_id: message_id}.to_json, status: 201) }
  let(:message_id) { 'amessageid'}

  describe '#send_message' do
    context 'when the message is sent successfully' do
      it 'sends a message to Provider1' do
        expect(Faraday).to receive(:new).and_return faraday
        expect(faraday).to receive(:post).and_return response
        response_hash = subject.send_message(message.uuid)
        expect(response_hash[:data]).to eq message_id
        expect(response_hash[:status]).to eq 'success'
      end
    end

    context "when there's an error" do
      let(:fail_response) { double(body: {error: message_error}.to_json, status: 201) }
      let(:message_error) { 'test error' }

      it 'returns the error' do
        expect(Faraday).to receive(:new).and_return faraday
        expect(faraday).to receive(:post).and_return fail_response
        response_hash = subject.send_message(message.uuid)
        expect(response_hash[:data]).to eq message_error
        expect(response_hash[:status]).to eq 'failed'
      end
    end
  end

  describe '#delivery_status_callback' do
    let(:remote_id){ 'a123message456id' }

    before do
      message.update(remote_id: remote_id)
    end

    context 'when delivered successfully' do
      let(:delivered_params) do
        {
          'status' => 'delivered',
          'message_id' => remote_id
        }
      end

      it 'updates the message appropriately' do
        post :delivery_status_callback, params: delivered_params
        expect(message.reload.status).to eq Message::STATUS[:delivered]
      end
    end

    context 'when delivery failed (invalid)' do
      let(:invalid_params) do
        {
          'status' => 'invalid',
          'message_id' => remote_id
        }
      end

      it 'updates the message appropriately (undeliverable, cause)' do
        post :delivery_status_callback, params: invalid_params
        message.reload
        expect(message.status).to eq Message::STATUS[:undeliverable]
        expect(message.status_info).to eq 'Invalid Phone Number'
      end
    end
  end
end