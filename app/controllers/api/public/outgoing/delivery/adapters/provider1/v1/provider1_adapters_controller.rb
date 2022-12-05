module Api
  module Public
    module Outgoing
      module Delivery
        module Adapters
          module Provider1
            module V1
              class Provider1AdaptersController < Api::Public::Outgoing::Delivery::Adapters::AdapterBase
                attr_reader :message, :call_response
                # Send Message to the third party
                # Update message.sent_at if successful
                # Handle error conditions
                def send_message(message_uuid)
                  Rails.logger.info("V1::Provider1AdaptersController: Processing #{message_uuid}")

                  return if !fetch_message(message_uuid: message_uuid)
                  @call_response = Faraday.new(url: base_url).post('provider1', request_params.to_json)
                  Rails.logger.info"Provider1AdaptersController: response for #{message_uuid}: status(#{@call_response.status}), body(#{@call_response.body})"
                  build_response
                end

                def adapter_name
                  'provider1'
                end

                # called by Provider as a response to send_message if send_message was successful
                # {
                #   status: 'delivered' or 'invalid' (phone)
                #   message_id: "uuid" returned in response by provider when message is sent
                # }
                def delivery_status_callback
                  return if !fetch_message(remote_id: params['message_id'])

                  case params['status']
                  when 'delivered'
                    @message.update(status: Message::STATUS[:delivered])
                  when 'invalid'
                    @message.update(status: Message::STATUS[:undeliverable], status_info: 'Invalid Phone Number')
                  else
                    Rails.logger.warn("V1::Provider1AdaptersController#delivery_status_callback Received unexpected status(#{params['status']}")
                  end
                  render json: {status: 'success'}, response_code: 200
                end

                private


                # @call_response.body can be
                # when there's a status
                #   'message_id' is the provider's id which is returned in the callback
                # if there is an error
                #   'error' => 'error message'
                def build_response
                  response_hash = {code: @call_response.status}
                  response_body = JSON.parse @call_response.body
                  if response_body['error']
                    response_hash[:status] = 'failed'
                    response_hash[:data] = response_body['error']
                  else
                    response_hash[:status] = 'success'
                    response_hash[:data] = response_body['message_id']
                  end
                  response_hash
                end

                def fetch_message(message_uuid: nil, remote_id: nil)
                  if remote_id
                    @message = Message.find_by(remote_id: remote_id)
                  else
                    @message = Message.find_by(uuid: message_uuid)
                  end
                  Rails.logger.warn("V1::Provider1Adapter Message not found for uuid: #{message_uuid} (deleted?)") if !message
                  !!@message
                end

                def provider1_params
                  params.permit(:message_id, :status, )
                end

                # curl -X POST -H "Content-Type: application/json" -d '{"to_number": "1112223333", "message": "This is my message", "callback_url": "https://63a6-38-44-145-216.ngrok.io/api/public/outgoing/delivery/adapters/provider1/v1/provider1_adapters/delivery_status_callback"}' "https://mock-text-provider.parentsquare.com/provider1"
                def request_params
                  {
                    to_number: @message.phone,
                    message: @message.body,
                    callback_url: callback_url
                  }
                end

                def base_url
                  'https://mock-text-provider.parentsquare.com'
                end
              end
            end
          end
        end
      end
    end
  end
end
