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
  class TestAdapter
    attr_reader :sent_at
    def initialize
      @sent_at = DateTime.now
    end
    def send_message(message_uuid)
      message = Message.find_by(uuid: message_uuid)
      message.update(sent_at: @sent_at)
    end
  end

  it 'will send the message to an adapter' do
    allow(TestAdapter).to receive(:new).and_return(adapter)
    subject.perform(message_uuid: message.uuid, adapter: 'TestAdapter')
    expect(message.reload.sent_at).to eq adapter.sent_at
  end
end
