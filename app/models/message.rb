#
# Fields
#   uuid
#   status
#   phone
#   body
# Indexes: uuid, status, phone
#
class Message < ApplicationRecord
  STATUS = {
    received: 'received',
    sent: 'sent',
    delivered: 'delivered'
  }
  scope :with_phone, ->(phone_number) { where("phone LIKE ?", "%#{phone_number}%") }
end