require 'rails_helper'
RSpec.describe Api::Public::Outgoing::Delivery::MessageDeliveryJob, type: :job do
  let(:message) do
    Message.create(
      status: Message::STATUS[:received],
      phone: Faker::PhoneNumber.cell_phone,
      body: Faker::Lorem.sentences
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
    end
  end

  it 'will send the message to an adapter' do
    allow(TestAdapter).to receive(:new).and_return(adapter)
    expect(adapter).to receive(:send_message).with(message.uuid)
    subject.perform(message_uuid: message.uuid, adapter: 'TestAdapter')
  end

  describe 'adapter response/error handling' do
    context 'when the adapter response is success' do
      it 'updates message.sent_at' do
        allow(TestAdapter).to receive(:new).and_return(adapter)
        subject.perform(message_uuid: message.uuid, adapter: 'TestAdapter')
        expect(message.reload.sent_at).to eq adapter.sent_at
        expect(message.status).to eq Message::STATUS[:sent]
      end
    end

    context 'when response is an exception' do
      it 'will not retry the job' do
        # expect it not to retry
        # expect message.status
        expect(false).to be "Implement adapter response errors!"
      end
    end

    context 'when the adapter response is a non-200 code' do
      it 'will not retry the job' do
        expect(false).to be "Implement adapter response errors!"
      end
    end
  end
end
