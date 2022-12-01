class DashController < ApplicationController
  def index
    @messages = [
      {
        'status' => 'sent',
        'phone' => '636-357-8304',
        'body' => 'Hi, Joe \n\n How are you doing?'
      },
      {
        'status' => 'received',
        'phone' => '636-352-6838',
        'body' => 'The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! The quick brown fox jumped over the lazy dog! '
      },
      {
        'status' => 'pending',
        'phone' => '636-357-8304',
        'body' => 'How about a quick round of golf?'
      }
    ]
  end
end
