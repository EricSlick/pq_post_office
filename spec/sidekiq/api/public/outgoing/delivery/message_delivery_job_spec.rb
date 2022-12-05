require 'rails_helper'
RSpec.describe Api::Public::Outgoing::Delivery::MessageDeliveryJob, type: :job do
  let(:message) do
    Message.create(
      status: Message::STATUS[:received],
      phone: Faker::PhoneNumber.cell_phone,
      body: Faker::Lorem.sentences,
      adapter: 'TestAdapter'
    ).reload
  end
  let(:adapter) { TestAdapter.new }
  let(:response_success){ Double(code: 200) }
  let(:response_fail){ Double(code: 400) }

  class TestAdapter
    attr_reader :sent_at
    def initialize
      @sent_at = DateTime.now
    end

    def send_message(message_uuid)
      message = Message.find_by(uuid: message_uuid)
      message.update(sent_at: @sent_at, status: Message::STATUS[:sent])
      {status: 'success', data: 'remote_id'}
    end

    def adapter_name
      'test'
    end
  end

  before do
    allow(TestAdapter).to receive(:new).and_return(adapter)
  end

  it 'will send the message to an adapter' do
    expect(adapter).to receive(:send_message).with(message.uuid)
    subject.perform(message.uuid)
  end

  describe 'adapter response/error handling' do
    context 'when the adapter response is success' do
      it 'updates message.sent_at and status' do
        subject.perform(message.uuid)
        expect(message.reload.sent_at).to eq adapter.sent_at
        expect(message.status).to eq Message::STATUS[:sent]
      end
    end

    context 'when response is an exception' do
      it 'will update message.status_info and not retry the job' do
        allow(adapter).to receive(:send_message).and_raise("Test Exception")
        expected_status_info = "Failed to send message to adapter(#{adapter.adapter_name}): Test Exception"
        subject.perform(message.uuid)
        expect(Api::Public::Outgoing::Delivery::MessageDeliveryJob).to_not have_enqueued_sidekiq_job
        expect(message.reload.status_info).to eq expected_status_info
      end
    end

    context 'when the adapter response is a non-200 code' do
      let(:response){ { status: 'failed', code: 400, data: 'response data from third party' } }

      it 'will update message.status_info and not retry the job' do
        allow(adapter).to receive(:send_message).and_return(response)
        subject.perform(message.uuid)
        expect(Api::Public::Outgoing::Delivery::MessageDeliveryJob).to_not have_enqueued_sidekiq_job
        expect(message.reload.status_info).to eq response[:data]
      end
    end

    context 'when the adapter response is 500' do
      let(:response){ { status: 'failed', code: 500, data: 'response data from third party' } }
      let(:adapter_manager) { Api::Public::Outgoing::Delivery::AdapterManager.new }

      it 'will retry sending the message passing in the failed adapter' do
        allow(adapter).to receive(:send_message).and_return(response)
        allow(Api::Public::Outgoing::Delivery::AdapterManager).to receive(:new).and_return adapter_manager
        allow(Message).to receive(:find_by).and_return message
        expect(adapter_manager).to receive(:deliver_without).with(['TestAdapter'], message)
        subject.perform(message.uuid)
      end
    end
  end
end
