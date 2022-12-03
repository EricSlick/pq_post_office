require 'faker'

module Api
  module Public
    module Incoming
      module Messages
        module V1
          class MessagesController < ApplicationController
            def create
              errors = []
              errors << "Missing phone number" if message_params[:phone].blank?
              errors << "Missing message body" if message_params[:body].blank?

              # waving hands and just hard coding this for simplicity but we should have a key
              # and we would then need users and that is out of scope for this exercise
              errors << "Invalid Key" if message_params[:key] != '12345' # hardcoded for simplicity
              Rails.logger.info("Company #{message_params[:key]} sent a message")

              if errors.length > 0
                render json: {errors: errors}.to_json, response_code: 400
              else
                message = create_new_message(build_new_message_params)
                if message.persisted?
                  render json: params.to_json
                else
                  render json: {error: {type: :internal, message_params: params, errors: message.errors.messages}}.to_json, response_code: 500
                end
              end
            end

            def create_test_data
              num = (message_params[:num] || 1).to_i
              (1..num).each do |_n|
                create_new_message(
                  status: Message::STATUS[:received],
                  phone: Faker::PhoneNumber.cell_phone,
                  body: Faker::Lorem.sentences(number: rand(1..5))
                )
              end

              render json: {:nothing => 'Stub response'}, response_code: 501
            end

            private

            def create_new_message(build_params)
              message = Message.new(build_params)
              message.save
              Api::Public::Outgoing::Delivery::AdapterManager.new.deliver(message)
              message
            end

            def build_new_message_params
              {
                status: Message::STATUS[:received],
                phone: params[:phone],
                body: params[:body]
              }
            end

            def message_params
              params.permit(:phone, :body, :key, :num)
            end
          end
        end
      end
    end
  end
end
