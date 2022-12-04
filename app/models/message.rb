#
# Fields
#   uuid
#   status: current status of the message (received, sent, delivered)
#   status_info: string with info on the current status
#   phone
#   body
#   adapter: name of adapter last used to send the message
#   sent_at: date_time message was sent to a provider
#   delivered_at: date_time message received a successful callback from provider
#   created_at: date_time message was created/received
#
# Indexes: uuid, status, phone
#
class Message < ApplicationRecord
  STATUS = {
    received: 'received',
    sent: 'sent',
    delivered: 'delivered',
    undeliverable: 'undeliverable'
  }
  scope :with_phone, ->(phone_number) { where("phone LIKE ?", "%#{phone_number}%") }
end