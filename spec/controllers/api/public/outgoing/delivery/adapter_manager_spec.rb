require 'rails_helper'

RSpec.describe Api::Public::Outgoing::Delivery::AdapterManager, type: :api do
  describe 'internal facing api' do
    describe '#deliver' do
      let(:message) do
        Message.create(
          status: Message::STATUS[:received],
          phone: phone,
          body: message_body
        )
      end
      let(:delivery_message) do
        {
          'to_number': message.phone,
          'message': message.body
        }
      end
      let(:phone){ Faker::PhoneNumber.cell_phone }
      let(:message_body){ Faker::Lorem.sentences(number: rand(1..5)) }
      let(:balance_manager){ Api::Public::Outgoing::Delivery::BalanceManager.new(adapters: [])}
      let(:adapter_stub) { 'StubAdapter' }

      it 'queues a sidekiq job for sending the message using a specified adapter' do
        message.reload
        expected_job_json = {
          message_uuid: message.uuid,
          adapter: adapter_stub
        }.to_json

        allow(Api::Public::Outgoing::Delivery::BalanceManager).to receive(:new).and_return balance_manager
        allow(balance_manager).to receive(:use_adapter).and_return adapter_stub
        subject.deliver(message)
        expect(Api::Public::Outgoing::Delivery::MessageDeliveryJob).to have_enqueued_sidekiq_job(expected_job_json)
      end
    end
  end
end