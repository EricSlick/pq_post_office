require 'rails_helper'

RSpec.describe Message do
  let(:subject){ Message.create(message_attributes) }
  let(:message_attributes) do
    {
      status: Message::STATUS[:received],
      phone: '5551231234',
      body: 'This is a test message'
    }
  end

  it 'exists' do
    expect(subject).to be_a Message
  end

  context 'scope :with_phone' do
    let(:message1){ subject }
    let(:message2){ Message.create(message2_attributes) }
    let(:message3){ Message.create(message3_attributes) }
    let(:message4){ Message.create(message4_attributes) }

    let(:message2_attributes) do
      {
        status: Message::STATUS[:sent],
        phone: phone2,
        body: 'This is test message 2'
      }
    end
    let(:message3_attributes) do
      {
        status: Message::STATUS[:delivered],
        phone: phone3,
        body: 'This is test message 3'
      }
    end
    let(:message4_attributes) do
      {
        status: Message::STATUS[:received],
        phone: phone2,
        body: 'This is test message 4'
      }
    end
    let(:phone2){ '5453214321' }
    let(:phone3){ '5553211234' }

    before do
      message1
      message2
      message3
      message4
    end

    context 'when the phone number is a complete number' do
      it 'returns messages attached to a particular phone number' do
        messages = Message.with_phone(phone2)
        expected_messages = [message2, message4]
        expect(messages).to match_array expected_messages
      end
    end

    context 'when the phone number is a partial number' do
      context 'and that number is the beginning of a phone number' do
        it 'returns all partially matching phone numbers' do
          partial_phone = '555'
          expected_messages = [message1, message3]
          messages = Message.with_phone(partial_phone)
          expect(messages).to match_array expected_messages
        end
      end

      context 'and that number is the end of a phone number' do
        it 'returns all partially matching phone numbers' do
          partial_phone = '1234'
          expected_messages = [message1, message3]
          messages = Message.with_phone(partial_phone)
          expect(messages).to match_array expected_messages
        end
      end

      context 'and that number is the middle of a phone number' do
        it 'returns all partially matching phone numbers' do
          partial_phone = '5321'
          expected_messages = [message2, message3, message4]
          messages = Message.with_phone(partial_phone)
          expect(messages).to match_array expected_messages
        end
      end
    end
  end
end